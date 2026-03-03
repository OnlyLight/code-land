output "dynamodb_table" {
  value = {
    name = aws_dynamodb_table.dynamodb_table.name
    arn  = aws_dynamodb_table.dynamodb_table.arn
  }
}
