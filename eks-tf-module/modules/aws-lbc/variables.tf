variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "helm_timeout" {
  type        = number
  description = "Timeout for Helm operations"
  default     = 300
}
