data "aws_availability_zones" "az" {
  state = "available"
}

resource "aws_subnet" "doun-subnet" {
  # data를 이용하여 가져온 리전 내에서 사용 가능한 가용 영역 설정 subnet 생성
  availability_zone       = data.aws_availability_zones.az.names[0]
  vpc_id                  = "<vpc id>"
  cidr_block              = "172.31.4.0/24"

  # 퍼블릭 IPv4 주소 자동 할당
  map_public_ip_on_launch = true

  tags = {
    # 서브넷 이름 
    Name = "doun-subnet"
  }
}
