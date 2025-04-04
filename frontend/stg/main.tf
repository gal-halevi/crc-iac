module "be_data" {
  source = "../../modules/frontend/common"
  env    = var.env
}

module "s3" {
  source                      = "../../modules/frontend/s3_bucket_for_static_website"
  bucket_name                 = "${var.bucket_name}-${var.env}"
  web_assets_path             = var.web_assets_path
  cloudfront_distribution_arn = module.cloudfront.cloudfront_distribution_arn
  config_json                 = local.config_json
  env                         = var.env
}

module "cloudfront" {
  source                      = "../../modules/frontend/cloudfront"
  bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  domain_list                 = local.domain_list
  default_root_object         = var.default_root_object
  certificate_arn             = ""
  env                         = var.env
}