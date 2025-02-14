# Create an OAC (Origin Access Control) for CloudFront
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "my-cloudfront-oac-${var.env}"
  description                       = "OAC for S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Create CloudFront distribution for serving the static website
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = var.bucket_regional_domain_name
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  enabled             = true
  default_root_object = var.default_root_object
  is_ipv6_enabled     = true
  aliases             = var.domain_list

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  default_cache_behavior {
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"
    # Using the CachingDisabled managed policy ID
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    cached_methods  = ["GET", "HEAD"]
    allowed_methods = ["GET", "HEAD"]
  }

  tags = {
    Environment = var.env
  }
}