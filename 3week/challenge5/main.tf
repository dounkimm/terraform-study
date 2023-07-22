data "aws_subnet" "doun-subnet" {
  id = "[subnet id]"
}

data "aws_security_group" "doun-sg" {
  id = "[security group id]"
}


variable "name" {
  type = string
  default = "3week-challenge5"
}

# resource "aws_instance" "test1" 
resource "aws_instance" "test2" {
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
    Name = var.name
  }
}

# moved 블록을 사용하여 test1을 test2로 이동
moved {
  from = aws_instance.test1
  to   = aws_instance.test2
}
