resource "aws_ecs_service" "backend" {
  name            = var.container_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
  }

  # this block to register your ECS service with ALB Target Group
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = 3000
  }

  tags = var.tags
}
