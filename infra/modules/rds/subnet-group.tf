resource "aws_db_subnet_group" "this" {
  name       = "postgres-subnet-group"
  subnet_ids = var.subnet_ids
}
