output "config" {
  value = {
    bucket         = aws_s3_bucket.s3_bucket.bucket
    region         = var.aws_region
    role_arn       = aws_iam_role.iam_role.arn
    dynamodb_table = aws_dynamodb_table.dynamodb_table.name
  }
}
