// use to configure-aws-credentials
output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}
