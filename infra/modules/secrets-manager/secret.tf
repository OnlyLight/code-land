resource "aws_secretsmanager_secret" "db" {
  name = var.name

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = var.secret_string

  lifecycle {
    precondition {
      condition     = length(trimspace(var.secret_string)) > 0
      error_message = "secret_string must be a non-empty string (GitHub secret/TF_VAR likely missing)."
    }
  }
}
