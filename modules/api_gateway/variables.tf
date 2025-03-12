variable "api_name" {
  description = "API name name to create"
}

variable "route_key" {
  description = "Route key to create"
}

variable "lambda_arn" {
  description = "Lambda arn for integrating it with the API"
}

variable "lambda_function_name" {
  description = "Lambda function name for setting permission"
}

variable "cors_allowed_origins" {
  type = list(string)
  description = "List of CORS allowed origins to set for the api gateway"
}