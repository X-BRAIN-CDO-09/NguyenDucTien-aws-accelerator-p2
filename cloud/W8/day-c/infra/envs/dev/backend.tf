terraform {
  backend "s3" {
    bucket       = "terraform-state-bucket-686543210"
    key          = "terraform/day-c/dev/terraform.tfstate"
    region       = "ap-southeast-1"
    encrypt      = true
    use_lockfile = true
  }
}