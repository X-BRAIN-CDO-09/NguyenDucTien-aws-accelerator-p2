output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

output "public_ec2_subnet_id" {
  description = "Public subnet ID used by the EC2 instance."
  value       = aws_subnet.public_ec2.id
}

output "alb_subnet_ids" {
  description = "Subnet IDs used by the ALB."
  value       = [aws_subnet.public_ec2.id, aws_subnet.public_alb.id]
}
