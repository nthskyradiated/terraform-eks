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
