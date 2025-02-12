variable "eks_cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "eks_cluster_version" {
  type        = string
  description = "Version of the EKS cluster"
}

variable "oidc_provider_arn" {
  type        = string
  description = "ARN of the OIDC Provider"
}

variable "oidc_provider_url" {
  type        = string
  description = "URL of the OIDC Provider"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "helm_timeout" {
  type        = number
  description = "Timeout for Helm operations in seconds"
  default     = 300
}

variable "secrets_namespace" {
  type        = string
  description = "Namespace for secrets store CSI driver"
  default     = "kube-system"
}