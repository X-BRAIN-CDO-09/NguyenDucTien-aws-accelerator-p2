locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "tls_private_key" "ssh" {
  algorithm = "ED25519"
}

resource "local_sensitive_file" "ssh_private_key" {
  filename        = "${path.root}/${local.name_prefix}-id_ed25519"
  content         = tls_private_key.ssh.private_key_openssh
  file_permission = "0600"
}

resource "aws_key_pair" "ssh" {
  key_name   = "${local.name_prefix}-ssh"
  public_key = tls_private_key.ssh.public_key_openssh
}

module "vpc" {
  source = "./modules/vpc"

  name_prefix            = local.name_prefix
  vpc_cidr               = var.vpc_cidr
  public_subnet_cidr     = var.public_subnet_cidr
  alb_public_subnet_cidr = var.alb_public_subnet_cidr
  availability_zone      = var.availability_zone
  alb_availability_zone  = var.alb_availability_zone
}

module "ec2" {
  source = "./modules/ec2"

  name_prefix      = local.name_prefix
  aws_region       = var.aws_region
  vpc_id           = module.vpc.vpc_id
  subnet_id        = module.vpc.public_ec2_subnet_id
  instance_type    = var.instance_type
  root_volume_size = var.root_volume_size
  key_name         = aws_key_pair.ssh.key_name
  allowed_ssh_cidr = var.allowed_ssh_cidr
  app_image        = var.app_image
  app_node_port    = var.app_node_port
}

module "alb" {
  source = "./modules/alb"

  name_prefix              = local.name_prefix
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.alb_subnet_ids
  target_instance_id       = module.ec2.instance_id
  target_security_group_id = module.ec2.security_group_id
  target_port              = var.app_node_port
}
