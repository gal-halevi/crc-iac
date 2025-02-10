variable "domain_name" {
  type = string
}

variable "domain_prefix" {
  type        = list(string)
  description = "Domain prefix to serve. e.g. www, mail, etc..."
}