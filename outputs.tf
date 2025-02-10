output "cloudfront_urls" {
  value = [for domain in aws_cloudfront_distribution.s3_distribution.aliases : "https://${domain}"]
}