output "config" {
  value = {
    bucket   = aws_s3_bucket.this.bucket
    role_arn = aws_iam_role.s3_backend.arn
  }
}
