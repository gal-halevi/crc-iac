variable "table_name" {
  default = "visitor_counter"
}

variable "primary_key" {
  default = "id"
}

variable "source_file_path" {
}

variable "lambda_name" {
  default = "crc-resume-counter"
}

variable "lambda_handler_name" {
  default = "lambda_handler"
}

variable "api_name" {
  default = "visitor_counter"
}

variable "api_route_key" {
  default = "POST /visitorCounter"
}

variable "api_cors_allowed_origins" {
  type = list(string)
  default = ["https://mycrc.site", "https://my.mycrc.site", "https://www.mycrc.site"]
}

variable "env" {
  type = string
}