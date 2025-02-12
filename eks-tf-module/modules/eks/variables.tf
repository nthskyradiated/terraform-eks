variable "env" {
  type        = string
  description = "Environment name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where EKS cluster will be created"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for EKS cluster"
}

variable "eks_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "eks_version" {
  type        = string
  description = "Kubernetes version for EKS cluster"
}

variable "desired_size" {
  type        = number
  description = "Desired size of node group"
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum size of node group"
  default     = 3
}

variable "min_size" {
  type        = number
  description = "Minimum size of node group"
  default     = 0
}

variable "instance_types" {
  type        = list(string)
  description = "List of instance types for the node group"
  default     = ["t2.medium"]
}

variable "cluster_endpoint_private_access" {
  type        = bool
  description = "Enable private access to the cluster endpoint"
  default     = true
}

variable "cluster_endpoint_public_access" {
  type        = bool
  description = "Enable public access to the cluster endpoint"
  default     = true
}
