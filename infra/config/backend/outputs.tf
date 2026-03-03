output "config" {
  value = {
    bucket   = module.s3.config.bucket
    region   = var.region
    role_arn = module.s3.config.role_arn
    # dynamodb_table = module.dynamodb.dynamodb_table
  }
}
