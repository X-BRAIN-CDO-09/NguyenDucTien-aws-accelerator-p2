variable "name_prefix" {
  type        = string
  description = "Prefix used for naming resources."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet hosting the EC2 instance."
}

variable "alb_public_subnet_cidr" {
  type        = string
  description = "CIDR block for the second public subnet required by the ALB."
}

variable "availability_zone" {
  type        = string
  description = "Availability zone for the EC2 subnet."
}

variable "alb_availability_zone" {
  type        = string
  description = "Availability zone for the ALB subnet."
}
