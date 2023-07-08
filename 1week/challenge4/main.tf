terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-2"
}

variable "vpc_id" {
  default = "[vpc id값]"
}

variable "key_name" {
  default = "[key pair name]"
}

variable "name" {
  default = "1week-challenge04"
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}


resource "aws_subnet" "test_subnet" {
  vpc_id            = data.aws_vpc.selected.id
  availability_zone = "ap-northeast-2a"
  cidr_block        = "172.31.5.0/24" 

  tags = {
    Name = "${var.name}-subnet" 
  }
}

resource "aws_instance" "test" {
  ami                         = "ami-0c9c942bd7bf113a2"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.test_subnet.id
  vpc_security_group_ids      = [aws_security_group.test_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  tags = {
    Name = var.name 
  }
}

resource "aws_security_group" "test_sg" {
  name = "${var.name}-sg"

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
  tags = {
    Name = "${var.name}-subnet"
  }
}
