resource "aws_security_group" "doun-sg" {
  vpc_id      = aws_vpc.doun-vpc.id
  name        = "doun T101 SG"
  description = "T101 Study SG"
}

resource "aws_security_group_rule" "doun-sginbound" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.doun-sg.id
}

resource "aws_security_group_rule" "doun-sgoutbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.doun-sg.id
}
