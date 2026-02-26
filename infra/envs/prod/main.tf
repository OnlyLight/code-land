locals {
  environment = terraform.workspace
  group       = "application"
}
module "network" {
  source   = "../../modules/network"
  vpc_cidr = "10.0.0.0/16"
  # azs = ["ap-southeast-1a"]
  # public_subnets  = ["10.0.1.0/24"]
  # private_subnets = ["10.0.11.0/24"]
  azs             = ["ap-southeast-1a", "ap-southeast-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]

  tags = {
    project     = var.project_name
    environment = local.environment
    group       = local.group
  }
}

resource "random_string" "bucket_suffix" {
  length  = 5
  special = false
  upper   = false
}

module "db_secret" {
  source        = "../../modules/secrets-manager"
  name          = "db-password-${random_string.bucket_suffix.result}"
  secret_string = var.db_password
  tags = {
    project     = var.project_name
    environment = local.environment
    group       = local.group
  }
}

module "alb_sg" {
  source = "../../modules/security-group"

  name   = "alb_sg"
  vpc_id = module.network.vpc_id

  ingress_rules = [{
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }]

  egress_rules = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]

  tags = {
    project     = var.project_name
    environment = local.environment
    group       = local.group
  }
}

module "ecs_sg" {
  source = "../../modules/security-group"

  name   = "ecs_sg"
  vpc_id = module.network.vpc_id

  ingress_rules = [{
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [module.alb_sg.security_group_id]
  }]

  egress_rules = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]

  tags = {
    project     = var.project_name
    environment = local.environment
    group       = local.group
  }
}

module "rds_sg" {
  source = "../../modules/security-group"

  name   = "rds_sg"
  vpc_id = module.network.vpc_id

  ingress_rules = [{
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.ecs_sg.security_group_id]
  }]

  egress_rules = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]

  tags = {
    project     = var.project_name
    environment = local.environment
    group       = local.group
  }
}

module "alb" {
  source          = "../../modules/alb"
  name            = "${var.project_name}-alb"
  vpc_id          = module.network.vpc_id
  public_subnets  = module.network.public_subnets
  security_groups = [module.alb_sg.security_group_id]

  tags = {
    project     = var.project_name
    environment = local.environment
    group       = local.group
  }
}

module "rds" {
  source                 = "../../modules/rds"
  db_name                = var.db_name
  username               = var.db_username
  db_secrets             = module.db_secret.db_secret_string
  subnet_ids             = module.network.private_subnets # private_subnet.
  vpc_security_group_ids = [module.rds_sg.security_group_id]
  multi_az               = false

  tags = {
    project     = var.project_name
    environment = local.environment
    group       = local.group
  }
}

module "ecs" {
  source         = "../../modules/ecs"
  family         = var.project_name
  container_name = var.project_name
  image          = var.container_image
  # image            = "${module.ecr_backend.repository_url}:latest"
  subnets          = module.network.private_subnets
  security_groups  = [module.ecs_sg.security_group_id]
  target_group_arn = module.alb.target_group_arn
  db_host          = module.rds.db_endpoint
  db_name          = var.db_name
  secret_arn       = module.db_secret.secret_arn

  tags = {
    project     = var.project_name
    environment = local.environment
    group       = local.group
  }
}

resource "aws_resourcegroups_group" "resourcegroups_group" {
  name = "${var.project_name}-application"

  resource_query {
    query = <<-JSON
      {
        "ResourceTypeFilters": [
          "AWS::AllSupported"
        ],
        "TagFilters": [
          {
            "Key": "project",
            "Values": ["${var.project_name}"]
          },
          {
            "Key": "environment",
            "Values": ["prod"]
          },
          {
            "Key": "group",
            "Values": ["application"]
          }
        ]
      }
    JSON
  }
}
