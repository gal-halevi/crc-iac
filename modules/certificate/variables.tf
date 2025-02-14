variable "domain_name" {
  type = string
}

variable "alternate_domains" {
  type = list(string)
}

variable "records_to_validate" {
}

variable "env" {
  type = string
}