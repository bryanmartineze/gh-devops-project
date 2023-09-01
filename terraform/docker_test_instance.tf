#Create docker instance for testing

resource "aws_key_pair" "docker_key" {
  key_name   = "docker_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


#fetching latest version of amazon linux
data "aws_ssm_parameter" "latest_amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

#Creation of security group

resource "aws_security_group" "docker-test" {
  name        = "docker-test-security-group"
  description = "Allow ports 22, 8080 and icmp"
  vpc_id      = var.default_vpc

  tags = {
    Name = "docker-test-security-group"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust this to restrict the IP range if needed
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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

#Creation of Test Instance
resource "aws_instance" "docker-instance" {
  ami           = data.aws_ssm_parameter.latest_amazon_linux_2023.value
  instance_type = "t3a.small" # Adjust as needed

  key_name        = aws_key_pair.docker_key.key_name
  security_groups = [aws_security_group.docker-test.id]

  subnet_id = var.default_subnet #default-vpc-public-subnet

  tags = {
    Name = "docker-test-instance"
  }

  depends_on = [aws_key_pair.docker_key, tls_private_key.rsa]
}