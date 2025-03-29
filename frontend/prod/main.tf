module "frontend" {
  source = "../../modules/frontend"
  env    = "prod"
}

output "cloudfront_urls" {
  value = module.frontend.cloudfront_urls
}
output "cloudfront_dist_id" {
  value = module.frontend.cloudfront_dist_id
}

output "BE_api_url" {
  value = module.frontend.BE_api_url
}