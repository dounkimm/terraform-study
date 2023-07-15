provider "aws" {
  region = "ap-northeast-2"
}

data "aws_subnet" "doun-subnet" {
  id = "<subnet id>"
}

data "aws_security_group" "doun-sg" {
  id = "<security group id>"
}

# ec2 변수 선언
# ec2 이름 = ec2 타입
variable "ec2" {
  default = {
    doun-ec2-1 = "t2.micro"
    doun-ec2-2 = "t2.nano"
    doun-ec2-3 = "t2.micro"
  }
}

# for_each를 사용하여 ec2 리소스 생성
resource "aws_instance" "test1" {
  for_each               = var.ec2
  ami                    = "ami-0c9c942bd7bf113a2"
  instance_type          = each.value
  subnet_id              = data.aws_subnet.doun-subnet.id
  vpc_security_group_ids = [data.aws_security_group.doun-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y apache2
              sudo echo "DoUn T101" > /var/www/html/index.html
              EOF

  tags = {
    Name = each.key
  }
}
