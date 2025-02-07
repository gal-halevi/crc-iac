variable "domain_name" {
  type = string
}

variable "domain_prefix" {
  type = list(string)
  description = "value for granted"
}

locals {
  alternate_domains = [for prefix in var.domain_prefix : "${prefix}.${var.domain_name}"]
  all_domains       = concat([var.domain_name], local.alternate_domains)
}