terraform {
  backend "s3" {
    bucket         = "codeland-terraform-state"
    key            = "environments/prod/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
