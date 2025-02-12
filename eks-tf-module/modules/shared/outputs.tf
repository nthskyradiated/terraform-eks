output "all" {
  value = {
    eks_cluster_name    = var.eks_cluster_name
    eks_cluster_version = var.eks_cluster_version  # Add this field
    oidc_provider_arn   = var.oidc_provider_arn
    oidc_provider_url   = var.oidc_provider_url
    vpc_id             = var.vpc_id
    subnet_ids         = var.subnet_ids
    region             = var.region
  }
}
