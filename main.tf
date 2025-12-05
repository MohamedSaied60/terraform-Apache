# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


# Get the latest Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create security group for web server
resource "aws_security_group" "web_sg" {
  name        = "apache-web-sg"
  description = "Security group for Apache web server"

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from anywhere"
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

  tags = {
    Name = "apache-security-group"
  }
}

# Create EC2 instance - Ubuntu
resource "aws_instance" "ubuntu_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.my_key.key_name
  user_data              = filebase64("user_data.sh")

  tags = {
    Name    = "apache-web-server-ubuntu"
    Project = "Terraform-Apache"
    Owner   = var.your_name
    OS      = "Ubuntu 22.04"
  }

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp2"
  }
}


# Create Elastic IP for Ubuntu
resource "aws_eip" "ubuntu_eip" {
  instance = aws_instance.ubuntu_server.id
  domain   = "vpc"

  tags = {
    Name = "apache-server-eip-ubuntu"
  }
}
# Create SSH key pair for Jenkins server
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "my_key" {
  key_name   = "my_key-ubuntu-${formatdate("YYYYMMDD", timestamp())}"
  public_key = tls_private_key.my_key.public_key_openssh
}

# Save private key locally
resource "local_file" "private_key" {
  content  = tls_private_key.my_key.private_key_pem
  filename = "my_key_key.pem"
  file_permission = "0400"
}