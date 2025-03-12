data "terraform_remote_state" "backend" {
  backend = "s3"
  config = {
    bucket = "crc-tf-state-bucket-iac"
    key    = "backendend.tfstate"
    region = "us-east-1"
  }
}

resource "local_file" "frontend_config" {
  filename = local.config_json_path
  content = jsonencode({
    apiUrl     = data.terraform_remote_state.backend.outputs.apiUrl
    tableName  = data.terraform_remote_state.backend.outputs.tableName
    primaryKey = data.terraform_remote_state.backend.outputs.primaryKey
  })
}

module "s3" {
  source                      = "../modules/s3_bucket_for_static_website"
  bucket_name                 = var.bucket_name
  web_assets_path             = var.web_assets_path
  cloudfront_distribution_arn = module.cloudfront.cloudfront_distribution_arn
  env                         = var.env
  depends_on                  = [local_file.frontend_config]
}

module "cloudfront" {
  source                      = "../modules/cloudfront"
  bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  domain_list                 = local.domain_list
  default_root_object         = var.default_root_object
  certificate_arn             = module.certificate.certificate_arn
  env                         = var.env
}

module "route53" {
  source                    = "../modules/route53"
  domain_name               = var.domain_name
  domain_validation_options = module.certificate.domain_validation_options
  domain_list               = local.domain_list
  cloudfront_domain         = module.cloudfront.domain_name
  cloudfront_hosted_zone_id = module.cloudfront.hosted_zone_id
}

module "certificate" {
  source              = "../modules/certificate"
  domain_name         = var.domain_name
  alternate_domains   = var.alternate_domains
  records_to_validate = module.route53.records
  env                 = var.env
}