aws_region   = "ap-southeast-1"
project_name = "terraform-lab"
environment  = "dev"

vpc_cidr             = "10.10.0.0/16"
public_subnet_cidrs  = ["10.10.1.0/24"]
private_subnet_cidrs = ["10.10.11.0/24", "10.10.12.0/24"]
availability_zones   = ["ap-southeast-1a", "ap-southeast-1b"]

instance_type    = "t3.micro"
key_name         = "singapore_region_key"
allowed_ssh_cidr = "0.0.0.0/0"

db_name           = "appdb"
db_username       = "admin"
db_password       = "Terraform12345#"
db_instance_class = "db.t3.micro"
