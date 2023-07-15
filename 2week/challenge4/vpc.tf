provider "aws" {
  region  = "ap-northeast-2"
}

resource "aws_vpc" "doun-vpc" {
  cidr_block       = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.tag}-study"
  }
}

resource "aws_subnet" "doun-subnet1" {
  vpc_id     = aws_vpc.doun-vpc.id
  cidr_block = "10.10.1.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "${local.tag}-subnet1"
  }
}

resource "aws_subnet" "doun-subnet2" {
  vpc_id     = aws_vpc.doun-vpc.id
  cidr_block = "10.10.2.0/24"

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "${local.tag}-subnet2"
  }
}


resource "aws_internet_gateway" "doun-igw" {
  vpc_id = aws_vpc.doun-vpc.id

  tags = {
    Name = "${local.tag}-igw"
  }
}

resource "aws_route_table" "doun-rt" {
  vpc_id = aws_vpc.doun-vpc.id

  tags = {
    Name = "${local.tag}-rt"
  }
}

resource "aws_route_table_association" "doun-rtassociation1" {
  subnet_id      = aws_subnet.doun-subnet1.id
  route_table_id = aws_route_table.doun-rt.id
}

resource "aws_route_table_association" "doun-rtassociation2" {
  subnet_id      = aws_subnet.doun-subnet2.id
  route_table_id = aws_route_table.doun-rt.id
}

resource "aws_route" "doun-defaultroute" {
  route_table_id         = aws_route_table.doun-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.doun-igw.id
}

output "aws_vpc_id" {
  value = aws_vpc.doun-vpc.id
}
