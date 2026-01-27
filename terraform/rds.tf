resource "aws_db_subnet_group" "this" {
  subnet_ids = [aws_subnet.private_db_a.id]
}

resource "aws_db_instance" "this" {
  identifier = "codeland-db"
  engine     = "postgres"
  engine_version = "15"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  db_name  = "codeland"
  username = "postgres"
  password = "postgres123"

  multi_az = false
  publicly_accessible = false

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name

  skip_final_snapshot = true
}
