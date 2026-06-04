output "vpc_id" {
  description = "VPC ID for the lab."
  value       = module.vpc.vpc_id
}

output "ec2_instance_id" {
  description = "EC2 instance ID of the minikube host."
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "Elastic IP attached to the minikube host."
  value       = module.ec2.public_ip
}

output "alb_dns_name" {
  description = "Public DNS name of the application load balancer."
  value       = module.alb.dns_name
}

output "aws_key_pair_name" {
  description = "AWS key pair name generated for the EC2 instance."
  value       = aws_key_pair.ssh.key_name
}

output "ssh_private_key_path" {
  description = "Local path to the generated SSH private key."
  value       = local_sensitive_file.ssh_private_key.filename
}

output "ssh_command" {
  description = "SSH command for accessing the minikube host."
  value       = "ssh -i ${local_sensitive_file.ssh_private_key.filename} ubuntu@${module.ec2.public_ip}"
}
