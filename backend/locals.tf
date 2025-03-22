locals {
  role_name = regex("role/(.+)$", var.role_arn)[0]
}