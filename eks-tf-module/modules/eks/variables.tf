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
  default     = 2
}

variable "max_size" {
  type        = number
  description = "Maximum size of node group"
  default     = 4
}

variable "min_size" {
  type        = number
  description = "Minimum size of node group"
  default     = 1
}

variable "instance_types" {
  type        = list(string)
  description = "List of instance types for the node group"
  default     = ["t3.medium"]
}
