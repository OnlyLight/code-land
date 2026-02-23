# // use to configure-aws-credentials
# output "role_arn" {
#   description = "IAM role ARN assumed by GitHub Actions"
#   value       = aws_iam_role.github_actions.arn
# }

# output "role_name" {
#   value = aws_iam_role.github_actions.name
# }

# output "vpc_id" {
#   value = module.network.vpc_id
# }

output "public_subnets" {
  value = module.network.public_subnets
}

output "private_subnets" {
  value = module.network.private_subnets
}
