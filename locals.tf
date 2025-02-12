locals {
  env         = var.env
  region      = var.region
  zone1       = "us-east-1a"
  zone2       = "us-east-1b"
  eks_name    = coalesce(var.eks_name, "pumpfactory-eks-${var.env}-${var.region}")
  eks_version = "1.32"
}