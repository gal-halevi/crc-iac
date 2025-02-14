variable "env" {
  type = string
}

variable "bucket_regional_domain_name" {
  type = string
}

variable "domain_list" {
  type = list(string)
}

variable "default_root_object" {
  type = string
}

variable "certificate_arn" {
  type = string
}