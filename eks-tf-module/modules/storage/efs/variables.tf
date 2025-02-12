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

variable "cluster_security_group_id" {
  type        = string
  description = "Security group ID specific to EFS module"
}
