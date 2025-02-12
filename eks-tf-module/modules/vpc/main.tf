resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.eks_name}-vpc"
    Environment = var.env
  }
}

resource "aws_subnet" "private_zone1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, 0)
  availability_zone = var.zone1

  tags = {
    Name                                    = "${var.eks_name}-private-${var.zone1}"
    Environment                             = var.env
    "kubernetes.io/role/internal-elb"       = 1
    "kubernetes.io/cluster/${var.eks_name}" = "shared"
  }
}

resource "aws_subnet" "private_zone2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, 1)
  availability_zone = var.zone2

  tags = {
    Name                                    = "${var.eks_name}-private-${var.zone2}"
    Environment                             = var.env
    "kubernetes.io/role/internal-elb"       = 1
    "kubernetes.io/cluster/${var.eks_name}" = "shared"
  }
}

resource "aws_subnet" "public_zone1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, 2)
  availability_zone       = var.zone1
  map_public_ip_on_launch = true

  tags = {
    Name                                    = "${var.eks_name}-public-${var.zone1}"
    Environment                             = var.env
    "kubernetes.io/role/elb"                = 1
    "kubernetes.io/cluster/${var.eks_name}" = "shared"
  }
}

resource "aws_subnet" "public_zone2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, 3)
  availability_zone       = var.zone2
  map_public_ip_on_launch = true

  tags = {
    Name                                    = "${var.eks_name}-public-${var.zone2}"
    Environment                             = var.env
    "kubernetes.io/role/elb"                = 1
    "kubernetes.io/cluster/${var.eks_name}" = "shared"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.eks_name}-igw"
    Environment = var.env
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "${var.eks_name}-nat-eip"
    Environment = var.env
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_zone1.id

  tags = {
    Name        = "${var.eks_name}-nat"
    Environment = var.env
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name        = "${var.eks_name}-private"
    Environment = var.env
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.eks_name}-public"
    Environment = var.env
  }
}

resource "aws_route_table_association" "private_zone1" {
  subnet_id      = aws_subnet.private_zone1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_zone2" {
  subnet_id      = aws_subnet.private_zone2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public_zone1" {
  subnet_id      = aws_subnet.public_zone1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_zone2" {
  subnet_id      = aws_subnet.public_zone2.id
  route_table_id = aws_route_table.public.id
}
