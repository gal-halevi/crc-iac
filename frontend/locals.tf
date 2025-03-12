locals {
  domain_list      = concat([var.domain_name], var.alternate_domains)
  config_json_path = "${var.web_assets_path}/config.json"
}