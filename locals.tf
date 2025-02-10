locals {
  s3_origin_id      = "myS3Origin"
  alternate_domains = [for prefix in var.domain_prefix : "${prefix}.${var.domain_name}"]
  all_domains       = concat([var.domain_name], local.alternate_domains)
}