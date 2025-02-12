variable "env" {
  type    = string
  default = "stg"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "zone1" {
  type    = string
  default = "us-east-1a"
}

variable "zone2" {
  type    = string
  default = "us-east-1b"
}

variable "eks_version" {
  type    = string
  default = "1.32"
}

variable "eks_name" {
  type    = string
  default = null

  validation {
    condition     = var.eks_name != null
    error_message = "eks_name must be provided"
  }
}

variable "vpc_cidr" {
  type    = string
  default = "10.244.0.0/16"
}

# Node group settings
variable "desired_size" {
  type        = number
  description = "Desired size of the node group"
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum size of the node group"
  default     = 3
}

variable "min_size" {
  type        = number
  description = "Minimum size of the node group"
  default     = 0
}

variable "instance_types" {
  type        = list(string)
  description = "List of EC2 instance types for the node group"
  default     = ["t2.medium"]
}

# Helm settings
variable "helm_timeout" {
  type        = number
  description = "Timeout for Helm operations in seconds"
  default     = 300
}

# Namespace settings
variable "secrets_namespace" {
  type        = string
  description = "Namespace for secrets store CSI driver"
  default     = "kube-system"
}

# Access settings
variable "cluster_endpoint_private_access" {
  type        = bool
  description = "Enable private access to the cluster endpoint"
  default     = false
}

variable "cluster_endpoint_public_access" {
  type        = bool
  description = "Enable public access to the cluster endpoint"
  default     = true
}
