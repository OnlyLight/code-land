resource "aws_lb" "this" {
  name               = var.name
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = var.security_groups
}
