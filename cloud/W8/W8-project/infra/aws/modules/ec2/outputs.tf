output "instance_id" {
  description = "EC2 instance ID."
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Elastic IP attached to the instance."
  value       = aws_eip.this.public_ip
}

output "security_group_id" {
  description = "Security group ID attached to the EC2 instance."
  value       = aws_security_group.this.id
}
