resource "aws_eip" "pumpfactory-eip" {
  domain = "vpc"
  tags = {
    Name = "pumpfactory-eip-${local.env}"
  }
}

resource "aws_nat_gateway" "pumpfactory-nat-gw" {
  allocation_id = aws_eip.pumpfactory-eip.id
  subnet_id     = aws_subnet.pumpfactory-subnet-public-1.id
  tags = {
    Name = "pumpfactory-nat-gw-${local.env}"
  }
  depends_on = [aws_internet_gateway.pumpfactory-igw]
}