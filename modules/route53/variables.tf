variable "domain_name" {
  type = string
}

variable "domain_validation_options" {
}

variable "domain_list" {
  type = list(string)
}

variable "cloudfront_domain" {
  type = string
}

variable "cloudfront_hosted_zone_id" {
  type = string
}