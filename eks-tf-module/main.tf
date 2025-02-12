module "vpc" {
  source   = "./modules/vpc"
  env      = var.env
  vpc_cidr = var.vpc_cidr
  eks_name = var.eks_name
  zone1    = var.zone1
  zone2    = var.zone2
}

module "eks" {
  source                    = "./modules/eks"
  env                       = var.env
  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = module.vpc.private_subnet_ids
  eks_name                  = var.eks_name
  eks_version               = var.eks_version
  endpoint_private_access   = var.cluster_endpoint_private_access
  endpoint_public_access    = var.cluster_endpoint_public_access
  depends_on                = [module.vpc]
}

# Shared module doesn't create resources, it just organizes variables
# It needs to get its values from vpc and eks modules
module "shared" {
  source              = "./modules/shared"
  eks_cluster_name    = module.eks.cluster_name
  eks_cluster_version = var.eks_version  # Add this line
  oidc_provider_arn   = module.eks.oidc_provider_arn
  oidc_provider_url   = module.eks.oidc_provider_url
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  region              = var.region
  depends_on          = [module.eks]  # Make explicit that we need EKS data
}

# All other modules that use shared variables should depend on both eks and shared
module "addons" {
  source     = "./modules/addons"
  shared     = module.shared.all
  depends_on = [module.eks, module.shared]
}

module "aws_lbc" {
  source       = "./modules/aws-lbc"
  cluster_name = module.eks.cluster_name
  vpc_id       = module.vpc.vpc_id
  shared       = module.shared.all
  helm_timeout = 300  # optional, using default value
  depends_on   = [module.eks, module.addons, module.shared]
}

module "ebs" {
  source            = "./modules/storage/ebs"  
  shared            = module.shared.all
  depends_on        = [module.eks, module.addons, module.shared]
}

module "efs" {
  source                    = "./modules/storage/efs"
  shared                    = module.shared.all
  cluster_security_group_id = module.eks.cluster_security_group_id
  depends_on                = [module.eks, module.addons, module.shared]
}

module "ingress" {
  source     = "./modules/ingress"
  depends_on = [module.eks, module.addons, module.aws_lbc, module.shared]
}

module "cert_manager" {
  source           = "./modules/cert-manager"
  depends_on       = [module.ingress, module.shared]
}

module "iam" {
  source           = "./modules/iam"
  eks_cluster_name = module.eks.cluster_name
  depends_on       = [module.eks, module.shared]
}
