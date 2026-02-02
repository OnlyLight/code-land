module "network" {
  source = "../../modules/network"
  vpc_cidr = "10.0.0.0/16"
  azs = ["ap-southeast-1a", "ap-southeast-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
}

module "ecr_backend" {
  source          = "../../modules/ecr"
  repository_name = "backend"
}

module "db_secret" {
  source = "../../modules/secrets-manager"
  name   = "db-password"
  secret_string = var.db_password
}

module "alb" {
  source          = "../../modules/alb"
  name            = "codeland-alb"
  vpc_id          = module.network.vpc_id
  public_subnets  = module.network.public_subnets
  security_groups = []
}

module "ecs" {
  source            = "../../modules/ecs"
  cluster_name      = "codeland"
  image             = module.ecr_backend.repository_url
  subnets           = module.network.private_subnets
  security_groups   = []
  target_group_arn = module.alb.target_group_arn
  db_host           = "rds-endpoint"
  db_name           = "codeland"
  db_secret_arn     = module.db_secret.secret_arn
}
