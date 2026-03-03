data "aws_caller_identity" "current" {}

locals {
  s3_backend_principals = length(var.principal_arns) > 0 ? var.principal_arns : [data.aws_caller_identity.current.arn]
}

data "aws_iam_policy_document" "s3_backend" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.this.arn]
  }

  statement {
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
  }
}

resource "aws_iam_policy" "s3_backend" {
  name   = "${title(var.project)}-s3-backend-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.s3_backend.json
}

resource "aws_iam_role" "s3_backend" {
  name = "${title(var.project)}-s3-backend-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = local.s3_backend_principals
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "s3_backend" {
  role       = aws_iam_role.s3_backend.name
  policy_arn = aws_iam_policy.s3_backend.arn
}

