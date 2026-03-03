locals {
  tags = {
    Project     = var.project_name
    Environment = terraform.workspace
    Group       = "configuration"
  }
}

module "dynamodb" {
  source  = "../../modules/dynamodb"
  project = var.project_name
  tags    = local.tags
}

resource "aws_resourcegroups_group" "resourcegroups_group" {
  name = "${var.project_name}-s3-backend"

  resource_query {
    query = <<-JSON
      {
        "ResourceTypeFilters": [
          "AWS::AllSupported"
        ],
        "TagFilters": [
          {
            "Key": "project",
            "Values": ["${var.project_name}"]
          },
          {
            "Key": "environment",
            "Values": ["prod"]
          },
          {
            "Key": "group",
            "Values": ["configuration"]
          }
        ]
      }
    JSON
  }
}
