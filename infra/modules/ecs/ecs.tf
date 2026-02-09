locals {
  db_secrets = jsondecode(var.db_secrets)
}

resource "aws_ecs_cluster" "this" {
  name = "${var.container_name}-cluster"

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }
}

resource "aws_ecs_task_definition" "backend" {
  family                   = var.family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512

  execution_role_arn = aws_iam_role.task_exec.arn

  container_definitions = jsonencode([
    {
      name  = var.container_name
      image = var.image

      portMappings = [{
        containerPort = 3000
      }]

      environment = [
        { name = "DB_HOST", value = var.db_host },
        { name = "DB_NAME", value = var.db_name }
      ]

      secrets = [
        {
          name      = "DB_PASSWORD"
          valueFrom = local.db_secrets.password
        }
      ]
    }
  ])
}
