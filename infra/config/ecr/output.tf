output "config" {
  value = {
    repository_url = module.ecr_backend.repository_url
    repository_arn = module.ecr_backend.repository_arn
  }
}
