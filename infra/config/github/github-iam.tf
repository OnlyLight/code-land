data "aws_caller_identity" "current" {}

locals {
  tags = {
    Project     = var.project_name
    Environment = terraform.workspace
    Group       = "configuration"
  }
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]

  tags = local.tags
}

resource "aws_iam_role" "github_actions" {
  name = "github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:OnlyLight/code-land:*"
          }
        }
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_policy" "github_ecr" {
  name = "${var.project_name}-github-ecr"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Resource = "*"
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_policy" "github_ecs" {
  name = "${var.project_name}-github-ecs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "ecs:UpdateService"
        ]
        Resource = "*"
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_policy" "github_terraform_backend" {
  name = "${var.project_name}-github-terraform-backend"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::codeland-s3-backend",
          "arn:aws:s3:::codeland-s3-backend/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [
          "arn:aws:s3:::codeland-s3-backend",
          "arn:aws:s3:::codeland-s3-backend/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = "arn:aws:dynamodb:ap-southeast-1:${data.aws_caller_identity.current.account_id}:table/codeland-s3-backend"
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "github_terraform_backend" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_terraform_backend.arn
}

resource "aws_iam_role_policy_attachment" "github_ecr" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_ecr.arn
}

resource "aws_iam_role_policy_attachment" "github_ecs" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_ecs.arn
}

# Permissions for Terraform apply (network, ECS, RDS, ALB, Secrets Manager, Resource Groups, IAM roles for ECS)
resource "aws_iam_policy" "github_terraform_apply" {
  name = "${var.project_name}-github-terraform-apply"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ResourceGroups"
        Effect = "Allow"
        Action = [
          "resource-groups:CreateGroup",
          "resource-groups:DeleteGroup",
          "resource-groups:GetGroup",
          "resource-groups:GetGroupQuery",
          "resource-groups:UpdateGroup",
          "resource-groups:UpdateGroupQuery",
          "resource-groups:ListGroups",
          "resource-groups:ListGroupResources",
          "resource-groups:Tag",
          "resource-groups:Untag"
        ]
        Resource = "*"
      },
      {
        Sid    = "ECS"
        Effect = "Allow"
        Action = [
          "ecs:CreateCluster",
          "ecs:DeleteCluster",
          "ecs:DescribeClusters",
          "ecs:CreateService",
          "ecs:UpdateService",
          "ecs:DeleteService",
          "ecs:DescribeServices",
          "ecs:RegisterTaskDefinition",
          "ecs:DeregisterTaskDefinition",
          "ecs:DescribeTaskDefinition",
          "ecs:ListClusters",
          "ecs:ListServices",
          "ecs:ListTaskDefinitions",
          "ecs:TagResource",
          "ecs:UntagResource"
        ]
        Resource = "*"
      },
      {
        Sid    = "IAMForECS"
        Effect = "Allow"
        Action = [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:GetRole",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies",
          "iam:PassRole",
          "iam:TagRole",
          "iam:UntagRole"
        ]
        Resource = "*"
      },
      {
        Sid    = "EC2VPC"
        Effect = "Allow"
        Action = [
          "ec2:AllocateAddress",
          "ec2:ReleaseAddress",
          "ec2:CreateVpc",
          "ec2:DeleteVpc",
          "ec2:CreateSubnet",
          "ec2:DeleteSubnet",
          "ec2:CreateInternetGateway",
          "ec2:DeleteInternetGateway",
          "ec2:AttachInternetGateway",
          "ec2:DetachInternetGateway",
          "ec2:CreateNatGateway",
          "ec2:DeleteNatGateway",
          "ec2:CreateRouteTable",
          "ec2:DeleteRouteTable",
          "ec2:CreateRoute",
          "ec2:DeleteRoute",
          "ec2:AssociateRouteTable",
          "ec2:DisassociateRouteTable",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:DescribeAddresses",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeNatGateways",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeAvailabilityZones"
        ]
        Resource = "*"
      },
      {
        Sid    = "SecretsManager"
        Effect = "Allow"
        Action = [
          "secretsmanager:CreateSecret",
          "secretsmanager:DeleteSecret",
          "secretsmanager:PutSecretValue",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:TagResource",
          "secretsmanager:UntagResource"
        ]
        Resource = "*"
      },
      {
        Sid    = "RDS"
        Effect = "Allow"
        Action = [
          "rds:CreateDBInstance",
          "rds:DeleteDBInstance",
          "rds:ModifyDBInstance",
          "rds:CreateDBSubnetGroup",
          "rds:DeleteDBSubnetGroup",
          "rds:DescribeDBInstances",
          "rds:DescribeDBSubnetGroups",
          "rds:AddTagsToResource",
          "rds:RemoveTagsFromResource"
        ]
        Resource = "*"
      },
      {
        Sid    = "ELB"
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:ModifyTargetGroupAttributes",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:RemoveTags",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeListeners"
        ]
        Resource = "*"
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "github_terraform_apply" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_terraform_apply.arn
}
