resource "aws_secretsmanager_secret" "db" {
  name = var.name
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
  # secret_string = var.secret_string
  secret_string = jsonencode({
    password = var.secret_string
  })
}

data "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
}
