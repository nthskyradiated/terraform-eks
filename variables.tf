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
