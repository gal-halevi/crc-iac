locals {
  domain_list = concat([var.domain_name], var.alternate_domains)
}