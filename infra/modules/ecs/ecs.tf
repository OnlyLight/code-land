resource "aws_ecs_cluster" "this" {
  name = "${var.container_name}-cluster"

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "ecs_backend" {
  name              = "${var.container_name}-log-group"
  retention_in_days = 14
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
      name  = "${var.container_name}-task-definition"
      image = var.image

      portMappings = [{
        containerPort = 3000
      }]

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:3000/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }

      environment = [
        { name = "DB_HOST", value = var.db_host },
        { name = "DB_NAME", value = var.db_name }
      ]

      secrets = [
        {
          name      = "DB_PASSWORD"
          valueFrom = var.secret_arn
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_backend.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = var.tags
}
