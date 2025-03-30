data "terraform_remote_state" "backend" {
  backend = "s3"
  config = {
    bucket = "crc-tf-state-bucket-iac-${var.env}"
    key    = "backend.tfstate"
    region = "us-east-1"
  }
}

module "s3" {
  source                      = "./s3_bucket_for_static_website"
  bucket_name                 = "${var.bucket_name}-${var.env}"
  web_assets_path             = var.web_assets_path
  cloudfront_distribution_arn = module.cloudfront.cloudfront_distribution_arn
  config_json                 = local.config_json
  env                         = var.env
}

module "cloudfront" {
  source                      = "./cloudfront"
  bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  domain_list                 = local.domain_list
  default_root_object         = var.default_root_object
  certificate_arn             = var.env == "prod" ? module.certificate.certificate_arn: ""
  env                         = var.env
}

module "route53" {
  count = var.env == "prod" ? 1 : 0
  source                    = "./route53"
  domain_name               = var.domain_name
  domain_validation_options = var.env == "prod" ? module.certificate.domain_validation_options : []
  domain_list               = local.domain_list
  cloudfront_domain         = module.cloudfront.domain_name
  cloudfront_hosted_zone_id = module.cloudfront.hosted_zone_id
  env                       = var.env
}

module "certificate" {
  count = var.env == "prod" ? 1 : 0
  source              = "./certificate"
  domain_name         = var.domain_name
  alternate_domains   = var.alternate_domains
  records_to_validate = var.env == "prod" ? module.route53.records : []
  env                 = var.env
}