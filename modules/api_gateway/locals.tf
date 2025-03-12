locals {
  stage = "default"
  resource_path = split("/", var.route_key)[1]
}