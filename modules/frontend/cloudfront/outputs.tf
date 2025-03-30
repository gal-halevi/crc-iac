output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.s3_distribution.arn
}

output "domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "hosted_zone_id" {
  value = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
}

output "cloudfront_urls" {
  value = var.env == "prod" ? [for domain in aws_cloudfront_distribution.s3_distribution.aliases : "https://${domain}"] : [aws_cloudfront_distribution.s3_distribution.domain_name]
}

output "distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}