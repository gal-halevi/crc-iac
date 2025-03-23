module "dynamodb" {
  source      = "../modules/dynamodb_table"
  table_name  = var.table_name
  primary_key = var.primary_key
}

module "lambda" {
  source             = "../modules/lambda_function"
  source_file_path   = var.source_file_path
  dynamodb_table_arn = module.dynamodb.table_arn
  lambda_name        = var.lambda_name
  handler            = var.lambda_handler_name
}

module "api_gateway" {
  source               = "../modules/api_gateway"
  api_name             = var.api_name
  lambda_function_name = var.lambda_name
  lambda_arn           = module.lambda.invoke_arn
  route_key            = var.api_route_key
  cors_allowed_origins = var.api_cors_allowed_origins
}