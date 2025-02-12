variable "shared" {
  type = object({
    eks_cluster_name    = string
    eks_cluster_version = string
    oidc_provider_arn   = string
    oidc_provider_url   = string
    region             = string
    vpc_id             = string
    subnet_ids         = list(string)
  })
  description = "Shared variables from the shared module"
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