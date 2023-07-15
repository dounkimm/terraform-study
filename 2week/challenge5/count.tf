provider "aws" {
  region = "ap-northeast-2"
}

# data 소스를 이용하여 기존에 생성되어 있던 subnet 사용
data "aws_subnet" "doun-subnet" {
  id = "<subnet id>"
}

# data 소스를 이용하여 기존에 생성되어 있던 security group 사용
data "aws_security_group" "doun-sg" {
  id = "<security group id>"
}


variable "name" {
  type = string
}

# count를 사용하여 리소스 생성
resource "aws_instance" "test1" {
  count                  = 3
  ami                    = "ami-0c9c942bd7bf113a2"
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.doun-subnet.id
  vpc_security_group_ids = [data.aws_security_group.doun-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y apache2
              sudo echo "DoUn T101" > /var/www/html/index.html
              EOF

  tags = {
    Name = "${var.name}-${count.index}"
  }
}
