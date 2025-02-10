locals {
  env         = "stg"
  region      = "us-east-1"
  zone1       = "us-east-1a"
  zone2       = "us-east-1b"
  eks_name    = "pumpfactory-eks-${local.env}-${local.region}"
  eks_version = "1.32"
}