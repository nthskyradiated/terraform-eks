resource "aws_internet_gateway" "pumpfactory-igw" {
  vpc_id = aws_vpc.pumpfactory-vpc-main.id
  tags = {
    Name = "pumpfactory-igw-${local.env}"
  }

}