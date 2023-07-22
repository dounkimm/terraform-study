# 조건문을 활용하여 (각자 편리한) AWS 리소스를 배포하는 코드 작성

variable "subnet_id" {
  default = "[subnet id]"
}

variable "key_name" {
  default = "[key name]"
}

variable "name" {
  type = list(string)
  default = ["3week-ec2-1", "3week-ec2-2"]
}

data "aws_subnet" "selected" {
  id = var.subnet_id
}


resource "aws_instance" "test" {
  # count에 조건문 사용 > 입력한 name의 list 값의 카운트가 2일 때 ec2 리소스 2개 생성
  # length를 이용하여 list 길이 구분
  count                       = length(var.name) == 2 ? length(var.name) : 0
  ami                         = "ami-0c9c942bd7bf113a2"
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.selected.id
  vpc_security_group_ids      = [aws_security_group.test_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  tags = {
    Name = var.name[count.index]
  }
}

resource "aws_security_group" "test_sg" {
  name = "3week-challenge1-sg"

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
    Name = "3week-challenge1-sg"
  }
}


output "myec2_public_ip" {
  value       = aws_instance.test[*].public_ip
  description = "The public IP of the Instance"
}
