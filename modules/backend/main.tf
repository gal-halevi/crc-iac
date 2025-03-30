module "dynamodb" {
  source      = "./dynamodb_table"
  table_name  = "${var.table_name}-${var.env}"
  primary_key = var.primary_key
  env         = var.env
}

module "lambda" {
  source             = "./lambda_function"
  source_file_path   = var.source_file_path
  dynamodb_table_arn = module.dynamodb.table_arn
  lambda_name        = "${var.lambda_name}-${var.env}"
  handler            = var.lambda_handler_name
  env                = var.env
}

module "api_gateway" {
  source               = "./api_gateway"
  api_name             = "${var.api_name}-${var.env}"
  lambda_function_name = "${var.lambda_name}-${var.env}"
  lambda_arn           = module.lambda.invoke_arn
  route_key            = var.api_route_key
  cors_allowed_origins = var.api_cors_allowed_origins
  env                  = var.env
}