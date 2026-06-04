variable "aws_region" {
  type        = string
  description = "AWS region for the lab."
}

variable "project_name" {
  type        = string
  description = "Project name used for resource naming."
}

variable "environment" {
  type        = string
  description = "Environment name."
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
  description = "Availability zone for the EC2 public subnet."
}

variable "alb_availability_zone" {
  type        = string
  description = "Second availability zone required by the ALB."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the minikube host."
}

variable "root_volume_size" {
  type        = number
  description = "Root EBS volume size in GiB for the minikube host."
  default     = 30
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR block allowed to SSH into EC2."
}

variable "app_image" {
  type        = string
  description = "ECR image URI that the EC2 host will preload into minikube."
}

variable "app_node_port" {
  type        = number
  description = "Fixed NodePort exposed by the application service inside minikube."
  default     = 30080
}
