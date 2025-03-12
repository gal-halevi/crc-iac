variable "source_file_path" {
  description = "Path to source file to deploy"
}

variable "lambda_name" {
  description = "Name of the lambda to create"
}

variable "handler" {
  description = "Handler function name"
}

variable "dynamodb_table_arn" {
  description = "DynamoDB table ARN"
}