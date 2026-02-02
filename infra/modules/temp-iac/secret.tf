resource "aws_secretsmanager_secret" "db" {
  name = "prod/db"
}

resource "random_password" "db" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id

  secret_string = jsonencode({
    dbname   = "codeland"
    password = random_password.db.result
  })
}

data "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
}
