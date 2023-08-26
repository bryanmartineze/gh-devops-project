resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "eks_cluster" {
  name = "attach-eks-cluster-policy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  roles      = [aws_iam_role.eks_cluster.name]
}

resource "aws_eks_cluster" "trainschedule" {
  name     = "trainschedule"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.25"  # Change this to your desired EKS version
  
  depends_on = [
    aws_iam_policy_attachment.eks_cluster,
  ]
  
  vpc_config {
      subnet_ids = [
          aws_subnet.private_subnet_1.id,  # Replace with the subnet IDs of your desired AZs
          aws_subnet.private_subnet_2.id,
          aws_subnet.private_subnet_3.id,
      ]
  }
}


resource "aws_eks_node_group" "trainschedule" {
  cluster_name    = aws_eks_cluster.trainschedule.name
  node_group_name = "trainschedule-node-group"
  node_role_arn = aws_iam_role.eks_cluster.arn
  
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
   }
   
  subnet_ids = [
    aws_subnet.private_subnet_1.id,  # Replace with the subnet IDs of your desired AZs
    aws_subnet.private_subnet_2.id,
    aws_subnet.private_subnet_3.id,
  ]
  
  # Add the block_device_mappings configuration for gp3 volumes
  launch_template {
    id = aws_launch_template.trainschedule.id
    version = "$Latest"  # Use the latest launch template version
  }

  depends_on = [
    aws_eks_cluster.trainschedule,
  ]
  
}

resource "aws_launch_template" "trainschedule" {
  name_prefix   = "trainschedule-launch-template"
  instance_type = "t3.small"  # Change this to your desired instance type

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 20
      volume_type = "gp3"
      throughput  = 125
    }
  }
}