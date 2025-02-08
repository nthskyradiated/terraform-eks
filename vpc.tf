resource "aws_vpc" "pumpfactory-vpc-main" {
  cidr_block           = "10.244.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "pumpfactory-vpc-${local.env}-main"
  }

}