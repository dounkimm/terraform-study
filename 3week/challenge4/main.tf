
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

resource "terraform_data" "foo" {
  triggers_replace = [
    aws_instance.test[0].id,
    aws_instance.test[1].id
  ]

  input = "world"
}

output "terraform_data_output" {
  value = terraform_data.foo.output  # 출력 결과는 "world"
}
