variable "env" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "eks_name" {
  type = string
}

variable "zone1" {
  type        = string
  description = "Availability zone 1 for VPC resources"
}

variable "zone2" {
  type        = string
  description = "Availability zone 2 for VPC resources"
}
