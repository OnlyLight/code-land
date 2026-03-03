module "ecr_backend" {
  source          = "../../modules/ecr"
  repository_name = var.project_name

  tags = {
    Environment = terraform.workspace
    Project     = var.project_name
    Group       = "configuration"
  }
}
