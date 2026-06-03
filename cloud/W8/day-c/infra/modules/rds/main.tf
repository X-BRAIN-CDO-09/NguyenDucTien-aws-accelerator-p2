resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}


resource "aws_security_group" "db" {
  name        = "${var.project_name}-${var.environment}-db-sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.environment}-db-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "mysql_from_ec2" {
  security_group_id            = aws_security_group.db.id
  referenced_security_group_id = var.allowed_app_sg_id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
}

resource "aws_db_instance" "this" {
  identifier             = "${var.project_name}-${var.environment}-mysql"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db.id]

  publicly_accessible = false
  multi_az            = false
  storage_type        = "gp2"
  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name = "${var.project_name}-${var.environment}-mysql"
  }
}

