# Create API gateway
resource "aws_apigatewayv2_api" "lambda_api" {
  name          = var.api_name
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = var.cors_allowed_origins
  }
}

# API Gateway V2 Stage (Auto Deploy Enabled)
resource "aws_apigatewayv2_stage" "http_stage" {
  api_id      = aws_apigatewayv2_api.lambda_api.id
  name        = local.stage
  auto_deploy = true
}

# API Gateway V2 Integration with Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.lambda_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.lambda_arn
}

# API Gateway V2 Route 
resource "aws_apigatewayv2_route" "lambda_route" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = var.route_key
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}


# Permission for API Gateway to Invoke Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # This allows API Gateway to invoke Lambda
  source_arn = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*"
}