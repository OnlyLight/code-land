output "secret_arn" {
  value = aws_secretsmanager_secret.db.arn
}

output "db_secret_string" {
  value     = aws_secretsmanager_secret_version.db.secret_string
  sensitive = true
}
