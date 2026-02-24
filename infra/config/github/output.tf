# use to configure-aws-credentials
output "config" {
  value = {
    role_arn  = aws_iam_role.github_actions.arn
    role_name = aws_iam_role.github_actions.name
  }
}
