output "db_instance_id" {
  value = aws_db_instance.this.id
}

output "endpoint" {
  value = aws_db_instance.this.endpoint
}

output "security_group_id" {
  value = aws_security_group.db.id
}
