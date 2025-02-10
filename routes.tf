resource "aws_route_table" "pumpfactory-private-rt" {
  vpc_id = aws_vpc.pumpfactory-vpc-main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.pumpfactory-nat-gw.id
  }
  tags = {
    Name = "pumpfactory-private-rt-${local.env}"
  }
}

resource "aws_route_table" "pumpfactory-public-rt" {
  vpc_id = aws_vpc.pumpfactory-vpc-main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pumpfactory-igw.id
  }
  tags = {
    Name = "pumpfactory-public-rt-${local.env}"
  }

}

resource "aws_route_table_association" "pumpfactory-private-rt-assoc-1" {
  subnet_id      = aws_subnet.pumpfactory-subnet-private-1.id
  route_table_id = aws_route_table.pumpfactory-private-rt.id
}

resource "aws_route_table_association" "pumpfactory-private-rt-assoc-2" {
  subnet_id      = aws_subnet.pumpfactory-subnet-private-2.id
  route_table_id = aws_route_table.pumpfactory-private-rt.id
}

resource "aws_route_table_association" "pumpfactory-public-rt-assoc-1" {
  subnet_id      = aws_subnet.pumpfactory-subnet-public-1.id
  route_table_id = aws_route_table.pumpfactory-public-rt.id
}

resource "aws_route_table_association" "pumpfactory-public-rt-assoc-2" {
  subnet_id      = aws_subnet.pumpfactory-subnet-public-2.id
  route_table_id = aws_route_table.pumpfactory-public-rt.id
}