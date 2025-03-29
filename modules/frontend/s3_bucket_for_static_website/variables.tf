variable "bucket_name" {
  type = string
}

variable "env" {
  type = string
}

variable "web_assets_path" {
  description = "Path to website files"
  type        = string
}

variable "config_json" {
  description = "config.json content"
}

variable "cloudfront_distribution_arn" {
  type = string
}