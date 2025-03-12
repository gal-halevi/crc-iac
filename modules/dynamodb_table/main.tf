resource "aws_dynamodb_table" "table" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.primary_key

  attribute {
    name = var.primary_key
    type = "S"
  }
}