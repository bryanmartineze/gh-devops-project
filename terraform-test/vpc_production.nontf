#Create VPC
resource "aws_vpc" "production_vpc" {
  enable_dns_support   = true
  enable_dns_hostnames = true
  cidr_block           = var.vpc_cidr
  tags = {
    Name = "production_vpc"
  }

}

#Create Internet Gateway
resource "aws_internet_gateway" "production_igw" {
  vpc_id = aws_vpc.production_vpc.id
  tags = {
    Name = "production_igw"
  }
}

#Data definition for the public_subnets
data "aws_availability_zones" "azs" {
  state = "available"
}

#Public subnets section
resource "aws_subnet" "public_subnet_1" {
  vpc_id                                      = aws_vpc.production_vpc.id
  map_public_ip_on_launch                     = true
  enable_resource_name_dns_a_record_on_launch = true
  availability_zone                           = element(data.aws_availability_zones.azs.names, 0)
  cidr_block                                  = var.public_subnet_cidr.a
  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                                      = aws_vpc.production_vpc.id
  map_public_ip_on_launch                     = true
  enable_resource_name_dns_a_record_on_launch = true
  availability_zone                           = element(data.aws_availability_zones.azs.names, 1)
  cidr_block                                  = var.public_subnet_cidr.b
  tags = {
    Name = "public_subnet_2"
  }
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id                                      = aws_vpc.production_vpc.id
  map_public_ip_on_launch                     = true
  enable_resource_name_dns_a_record_on_launch = true
  availability_zone                           = element(data.aws_availability_zones.azs.names, 2)
  cidr_block                                  = var.public_subnet_cidr.c
  tags = {
    Name = "public_subnet_3"
  }
}

#Private subnets section
resource "aws_subnet" "private_subnet_1" {
  vpc_id                                      = aws_vpc.production_vpc.id
  enable_resource_name_dns_a_record_on_launch = true
  availability_zone                           = element(data.aws_availability_zones.azs.names, 0)
  cidr_block                                  = var.private_subnet_cidr.a
  tags = {
    Name = "private_subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                                      = aws_vpc.production_vpc.id
  enable_resource_name_dns_a_record_on_launch = true
  availability_zone                           = element(data.aws_availability_zones.azs.names, 1)
  cidr_block                                  = var.private_subnet_cidr.b
  tags = {
    Name = "private_subnet_2"
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id                                      = aws_vpc.production_vpc.id
  enable_resource_name_dns_a_record_on_launch = true
  availability_zone                           = element(data.aws_availability_zones.azs.names, 2)
  cidr_block                                  = var.private_subnet_cidr.c
  tags = {
    Name = "private_subnet_3"
  }
}

#NAT Gateway Creation
resource "aws_eip" "nat_gateway_eip" {
  tags = {
    Name = "Production_nat_gateway_eip"
  }
}

resource "aws_nat_gateway" "production_nat_gateway" {
  subnet_id     = aws_subnet.public_subnet_1.id
  allocation_id = aws_eip.nat_gateway_eip.id
  tags = {
    Name = "production_ngw"
  }
}

#Route table creation section

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.production_vpc.id

  route {
    gateway_id = aws_internet_gateway.production_igw.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.production_vpc.id
  route {
    nat_gateway_id = aws_nat_gateway.production_nat_gateway.id
    cidr_block     = "0.0.0.0/0"
  }
  tags = {
    Name = "private_route_table"
  }

}

#Public route table association section
resource "aws_route_table_association" "public_route_table_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table_association_3" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public_route_table.id
}



#Private route table association section
resource "aws_route_table_association" "private_route_table_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table_association_3" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private_route_table.id
}

#Security Group creation section
resource "aws_security_group" "ssh_access" {
  name        = "ssh_access"
  description = "Allows port 22"
  vpc_id      = aws_vpc.production_vpc.id

  tags = {
    Name = "ssh_access"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb" {
  name   = "eks-alb"
  vpc_id = aws_vpc.production_vpc.id

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  ingress {
    description      = "trainschedule"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "eks-alb"
  }
}

# resource "aws_security_group" "eks_worker_ports" {
#   name        = "eks_worker_ports"
#   description = "Ports for the worker nodes"
#   vpc_id      = aws_vpc.production_vpc.id

#   tags = {
#     Name = "eks_worker_ports"
#   }

#   ingress {
#     from_port   = 3000
#     to_port     = 32767
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "NodePort Service"
#   }

#   ingress {
#     from_port   = 10250
#     to_port     = 10250
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.0.0/16"]
#     description = "kubelet API"
#   }

#   ingress {
#     from_port   = 8472
#     to_port     = 8472
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.0.0/16"]
#     description = "Cluster-Wide Network Comm - Flannel VXLAN"
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

# }