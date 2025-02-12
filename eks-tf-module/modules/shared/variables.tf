variable "eks_cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "oidc_provider_arn" {
  type        = string
  description = "ARN of the OIDC Provider"
}

variable "oidc_provider_url" {
  type        = string
  description = "URL of the OIDC Provider"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where EKS is deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for EKS deployment"
}

variable "region" {
  type        = string
  description = "AWS region"
}

output "all" {
  value = {
    eks_cluster_name  = var.eks_cluster_name
    oidc_provider_arn = var.oidc_provider_arn
    oidc_provider_url = var.oidc_provider_url
    vpc_id           = var.vpc_id
    subnet_ids       = var.subnet_ids
    region           = var.region
  }
}
