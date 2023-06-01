terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Provider AWS
provider "aws" {
  #access_key = "SUA_ACCESS_KEY"
  access_key = "AKIAS7KKJFB6X2BJJJLG"
  #secret_key = "SUA_SECRET_KEY"
  secret_key = "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"
  region     = "us-east-1"
}

# Recurso VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Recurso Subnet
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
}

# Recurso Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Recurso Rota
resource "aws_route" "my_route" {
  route_table_id         = aws_vpc.my_vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# Recurso Security Group
resource "aws_security_group" "my_sg" {
  name        = "my-security-group"
  description = "Security group for EC2 instance"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
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

resource "null_resource" "docker_provisioner" {
  connection {
    host        = aws_instance.i-0d7236d80192af092.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("D:/backup/usuario/Documents/Monick/magazord-test/AcerKey.ppk")
  }

  provisioner "local-exec" {
    command = <<-EOT
      ssh -i D:\backup\usuario\Documents\Monick\magazord-test\AcerKey.ppk ec2-user@${self.connection.host} \
      "docker run -d -p 8080:80 php:latest"
    EOT
  }

  depends_on = [aws_instance.my_instance]
}

# Recurso Instância EC2
resource "aws_instance" "my_ec2" {
  #ami                    = "AMAZON_AMI_ID"
  ami                    = "ami-0e322da50e0e90e21"
  instance_type          = "t2.micro"
  #key_name               = "NOME_DA_CHAVE"
  key_name               = "AcerKey"
  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
}

# Recurso Docker - Apache + PHP
resource "docker_provisioner" "my_container" {
  provider = aws
  name  = "my-container"
  image = "php:latest"

  ports {
    internal = 80
    external = 8080
  }
}

# Recurso Docker - Jenkins
resource "null_resource" "jenkins_container" {
  provider = aws
  name  = "jenkins-container"
  image = "jenkins/jenkins:lts"

  ports {
    internal = 8080
    external = 8081
  }

  volumes {
    container_path  = "/var/jenkins_home"
    host_path       = "/path/to/jenkins/home"
    read_only       = false
  }
}
