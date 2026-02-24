output "config" {
  value = {
    bucket         = module.dynamodb.config.bucket
    region         = var.region
    role_arn       = module.dynamodb.config.role_arn
    dynamodb_table = module.dynamodb.config.dynamodb_table
  }
}
