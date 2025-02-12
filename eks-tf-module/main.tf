module "vpc" {
  source   = "./modules/vpc"
  env      = var.env
  vpc_cidr = var.vpc_cidr
  eks_name = var.eks_name
  zone1    = var.zone1
  zone2    = var.zone2
}

module "eks" {
  source      = "./modules/eks"
  env         = var.env
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnet_ids
  eks_name    = var.eks_name
  eks_version = var.eks_version
  depends_on  = [module.vpc]
}

module "addons" {
  source              = "./modules/addons"
  eks_cluster_name    = module.eks.cluster_name
  eks_cluster_version = var.eks_version
  region              = var.region
  oidc_provider_arn   = module.eks.oidc_provider_arn
  oidc_provider_url   = module.eks.oidc_provider_url
  depends_on          = [module.eks]
}

module "aws_lbc" {
  source       = "./modules/aws-lbc"
  cluster_name = module.eks.cluster_name
  vpc_id       = module.vpc.vpc_id
  depends_on   = [module.eks, module.addons]
}

module "ebs" {
  source            = "./modules/storage/ebs"
  eks_cluster_name  = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
  depends_on        = [module.eks, module.addons]
}

module "efs" {
  source                    = "./modules/storage/efs"
  eks_cluster_name          = module.eks.cluster_name
  vpc_id                    = module.vpc.vpc_id
  private_subnet_ids        = module.vpc.private_subnet_ids
  cluster_security_group_id = module.eks.cluster_security_group_id
  oidc_provider_arn         = module.eks.oidc_provider_arn
  oidc_provider_url         = module.eks.oidc_provider_url
  depends_on                = [module.eks, module.addons]
}

module "ingress" {
  source           = "./modules/ingress"
  eks_cluster_name = module.eks.cluster_name
  depends_on       = [module.eks, module.addons, module.aws_lbc]
}

module "iam" {
  source           = "./modules/iam"
  eks_cluster_name = module.eks.cluster_name
  depends_on       = [module.eks]
}

module "eks_cluster" {
  source      = "./tf-module"
  env         = var.env
  region      = var.region
  zone1       = var.zone1
  zone2       = var.zone2
  eks_version = var.eks_version
  eks_name    = var.eks_name
  vpc_cidr    = var.vpc_cidr
}
