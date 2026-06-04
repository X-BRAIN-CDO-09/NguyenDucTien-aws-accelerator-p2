variable "name_prefix" {
  type        = string
  description = "Prefix used for naming resources."
}

variable "aws_region" {
  type        = string
  description = "AWS region used for ECR authentication."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the EC2 resources."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID where the EC2 instance will run."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the minikube host."
}

variable "root_volume_size" {
  type        = number
  description = "Root EBS volume size in GiB for the EC2 instance."
}

variable "key_name" {
  type        = string
  description = "AWS key pair name attached to the EC2 instance."
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR block allowed to SSH into EC2."
}

variable "app_image" {
  type        = string
  description = "ECR image URI that should be preloaded into minikube."
}

variable "app_node_port" {
  type        = number
  description = "Fixed NodePort exposed by the application service."
}
