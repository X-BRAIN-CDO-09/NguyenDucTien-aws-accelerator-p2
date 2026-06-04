variable "name_prefix" {
  type        = string
  description = "Prefix used for naming resources."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID used by the ALB."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs attached to the ALB."
}

variable "target_instance_id" {
  type        = string
  description = "EC2 instance ID registered in the target group."
}

variable "target_security_group_id" {
  type        = string
  description = "Security group ID attached to the EC2 target."
}

variable "target_port" {
  type        = number
  description = "Port exposed on the EC2 host that the ALB forwards to."
}
