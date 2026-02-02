resource "aws_db_instance" "this" {
  engine            = "postgres"
  engine_version    = "15.4"
  instance_class    = "db.t3.micro"

  allocated_storage = 20
  db_name           = var.db_name
  username          = var.username
  password          = var.password

  multi_az               = var.multi_az
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids

  skip_final_snapshot = true
}
