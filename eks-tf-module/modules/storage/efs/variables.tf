variable "eks_cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where EKS cluster is deployed"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"
}

variable "cluster_security_group_id" {
  type        = string
  description = "Security group ID of the EKS cluster"
}

variable "oidc_provider_arn" {
  type        = string
  description = "ARN of the OIDC Provider"
}

variable "oidc_provider_url" {
  type        = string
  description = "URL of the OIDC Provider"
}
