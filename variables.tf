variable "bucket_name" {
  type = string
}

variable "web_assets_path" {
  type = string
}

variable "env" {
  type        = string
  description = "Environment type: prod/stg"
}

variable "domain_name" {
  type = string
}

variable "alternate_domains" {
  type = list(string)
}

variable "default_root_object" {
  type = string
}