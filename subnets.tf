resource "aws_subnet" "pumpfactory-subnet-private-1" {
  vpc_id            = aws_vpc.pumpfactory-vpc-main.id
  cidr_block        = "10.244.0.0/19"
  availability_zone = local.zone1
  tags = {
    Name                                                   = "pumpfactory-subnet-private-1-${local.env}-${local.zone1}"
    "kubernetes.io/role/internal-elb"                      = "1"
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
  }
}

resource "aws_subnet" "pumpfactory-subnet-private-2" {
  vpc_id            = aws_vpc.pumpfactory-vpc-main.id
  cidr_block        = "10.244.32.0/19"
  availability_zone = local.zone2
  tags = {
    Name                                                   = "pumpfactory-subnet-private-2-${local.env}-${local.zone2}"
    "kubernetes.io/role/internal-elb"                      = "1"
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
  }
}

resource "aws_subnet" "pumpfactory-subnet-public-1" {
  vpc_id                  = aws_vpc.pumpfactory-vpc-main.id
  cidr_block              = "10.244.64.0/19"
  availability_zone       = local.zone1
  map_public_ip_on_launch = true
  tags = {
    Name                                                   = "pumpfactory-subnet-public-1-${local.env}-${local.zone1}"
    "kubernetes.io/role/elb"                               = "1"
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
  }

}

resource "aws_subnet" "pumpfactory-subnet-public-2" {
  vpc_id                  = aws_vpc.pumpfactory-vpc-main.id
  cidr_block              = "10.244.96.0/19"
  availability_zone       = local.zone2
  map_public_ip_on_launch = true
  tags = {
    Name                                                   = "pumpfactory-subnet-public-2-${local.env}-${local.zone2}"
    "kubernetes.io/role/elb"                               = "1"
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
  }

}