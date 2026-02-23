resource "aws_secretsmanager_secret" "db" {
  name = var.name

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = var.secret_string
}
