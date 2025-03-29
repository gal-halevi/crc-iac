output "invoke_url" {
  value = "${aws_apigatewayv2_api.lambda_api.api_endpoint}/${local.stage}/${local.resource_path}"
}