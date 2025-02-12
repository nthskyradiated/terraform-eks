variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where EKS cluster is deployed"
}

variable "helm_timeout" {
  type        = number
  description = "Timeout for Helm operations in seconds"
  default     = 300
}

variable "shared" {
  type = object({
    eks_cluster_name  = string
    oidc_provider_arn = string
    oidc_provider_url = string
    vpc_id           = string
    subnet_ids       = list(string)
    region           = string
  })
  description = "Shared variables from the shared module"
}
