output "cloudfront_urls" {
  value = module.cloudfront.cloudfront_urls
}
output "cloudfront_dist_id" {
  value = module.cloudfront.distribution_id
}

output "BE_api_url" {
  value = data.terraform_remote_state.backend.apiUrl
}