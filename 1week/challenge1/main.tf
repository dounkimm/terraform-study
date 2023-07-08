provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_instance" "test1" {
  ami                    = "ami-0c9c942bd7bf113a2"
  instance_type          = "t2.micro"
  subnet_id             = "${subnet id}"
  vpc_security_group_ids = [aws_security_group.instance.id]
  
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y apache2
              sudo echo "DoUn T101" > /var/www/html/index.html
              EOF

  tags = {
    Name = "1week-challenge01"
  }
}

resource "aws_security_group" "instance" {
  name = var.security_group_name

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "terraform-test1-instance"
}

output "public_ip" {
  value       = aws_instance.test1.public_ip
  description = "The public IP of the Instance"
}
