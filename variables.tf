variable "env" {
  type        = string
  default     = "stg"
  description = "Environment name"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "zone1" {
  type        = string
  default     = "us-east-1a"
  description = "First availability zone"
}

variable "zone2" {
  type        = string
  default     = "us-east-1b"
  description = "Second availability zone"
}

variable "eks_version" {
  type        = string
  default     = "1.32"
  description = "EKS cluster version"
}

variable "eks_name" {
  type        = string
  description = "Name of the EKS cluster"

  validation {
    condition     = var.eks_name != null
    error_message = "eks_name must be provided"
  }
}

variable "vpc_cidr" {
  type        = string
  default     = "10.244.0.0/16"
  description = "CIDR block for VPC"
}

# Add missing variables used by modules
variable "cluster_endpoint_public_access" {
  type        = bool
  default     = true
  description = "Enable public access to cluster endpoint"
}

variable "cluster_endpoint_private_access" {
  type        = bool
  default     = true
  description = "Enable private access to cluster endpoint"
}
