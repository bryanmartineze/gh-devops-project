
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "trainschedule"
  cluster_version = "1.24"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets
  
  enable_irsa = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = "arn:aws:iam::${var.aws_account_id}:role/${module.eks.cluster_name}-ebs-csi-controller"
    }
  }
  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.small", "t3.medium", "t3.large", "t3a.small", "t3a.medium", "t3a.large"]
  }

  eks_managed_node_groups = {
    trainschedule_nodes = {
      min_size     = 1
      max_size     = 2
      desired_size = 2
      instance_types = ["t3a.large"]
      
      capacity_type  = "SPOT"
      network_interfaces = [{
        delete_on_termination       = true
        associate_public_ip_address = true
    }]
    
    }
  }

  cluster_security_group_additional_rules = {
    ingress_all_443_api = {
      description = "API all ingress"
      protocol = "tcp"
      from_port = 443
      to_port = 443
      type = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      }
  }
  
  node_security_group_additional_rules = {
    # allow connections from ALB security group
    ingress_allow_access_from_alb_sg = {
      type                     = "ingress"
      protocol                 = "-1"
      from_port                = 0
      to_port                  = 0
      source_security_group_id = aws_security_group.alb.id
    }
    
    # allow connections from EKS to EKS (internal calls)
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol = "-1"
      from_port = 0
      to_port = 0
      type = "ingress"
      self = true
    }
    
    # allow connections from EKS to the internet
    egress_all = {
      description = "Node all egress"
      protocol = "-1"
      from_port = 0
      to_port = 0
      type = "egress"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
     }
  }
  

  # aws-auth configmap
  manage_aws_auth_configmap = true

  # aws_auth_roles = [
  #   {
  #     rolearn  = "arn:aws:iam::66666666666:role/role1"
  #     username = "role1"
  #     groups   = ["system:masters"]
  #   },
  # ]

  aws_auth_users = [
    {
      userarn  = var.aws_eks_admin1_arn
      username = "swo-admin"
      groups   = ["system:masters"]
    },
    {
      userarn  = var.aws_eks_admin2_arn
      username = "eks-admin"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_accounts = [
    var.aws_account_id,
    
  ]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

data "aws_eks_cluster" "trainschedule" {
  name       = module.eks.cluster_name
  depends_on = [module.eks.cluster_name]
}

data "aws_eks_cluster_auth" "trainschedule" {
  name       = module.eks.cluster_name
  depends_on = [module.eks.cluster_name]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.trainschedule.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.trainschedule.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.trainschedule.token
}

provider "helm" {
  kubernetes {
  host                   = data.aws_eks_cluster.trainschedule.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.trainschedule.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.trainschedule.token
  }
}

# deploy spot termination handler
resource "helm_release" "spot_termination_handler" {
  name          = "aws-node-termination-handler"
  chart         = "aws-node-termination-handler"
  repository    = "https://aws.github.io/eks-charts"
  version       = "0.21.0"
  namespace     = "kube-system"
  wait_for_jobs = true
}