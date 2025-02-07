# Create local for using experssion more than once
locals {
  s3_origin_id = "myS3Origin"
}

# Create S3 bucket for static website hosting
resource "aws_s3_bucket" "resume-frontend-bucket" {
  bucket = "resume-frontend-bucket-xxssa"

  tags = {
    Name        = "Resume Frontend Bucket"
    Environment = "production"
  }
}

# Upload website file
resource "aws_s3_object" "html_file" {
  bucket       = aws_s3_bucket.resume-frontend-bucket.id
  source       = "../frontend/index.html"
  key          = "index.html"
  content_type = "text/html"
}

# Upload website file
resource "aws_s3_object" "css_file" {
  bucket       = aws_s3_bucket.resume-frontend-bucket.id
  source       = "../frontend/styles.css"
  key          = "styles.css"
  content_type = "text/css"
}

# Create an OAC (Origin Access Control) for CloudFront
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "my-cloudfront-oac"
  description                       = "OAC for S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Create CloudFront distribution for serving the static website
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.resume-frontend-bucket.bucket_regional_domain_name
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  enabled             = true
  default_root_object = "index.html"
  is_ipv6_enabled     = true
  aliases             = local.all_domains

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.cert.certificate_arn
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
}

# Add policy to S3 bucket for allowing CloudFront to use it
resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.resume-frontend-bucket.id
  policy = <<POLICY
{
"Version": "2008-10-17",
"Id": "PolicyForCloudFrontPrivateContent",
"Statement": [
    {
        "Sid": "AllowCloudFrontServicePrincipal",
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudfront.amazonaws.com"
        },
        "Action": "s3:GetObject",
        "Resource": "${aws_s3_bucket.resume-frontend-bucket.arn}/*",
        "Condition": {
            "StringEquals": {
                "AWS:SourceArn": "${aws_cloudfront_distribution.s3_distribution.arn}"
            }
        }
    }
]
}
POLICY
}

# Get a previously created hosted zone
data "aws_route53_zone" "hosted_zone" {
  name         = var.domain_name
  private_zone = false
}

# Create a public certificate
resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = local.alternate_domains
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

# Add certificate records to the hosted zone
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = each.value.name
  records = [each.value.record]
  type    = each.value.type
  ttl     = 60
}

# Validate the certificate
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# Create Route 53 alias record pointing to CloudFront
resource "aws_route53_record" "cf_alias" {
  for_each = toset(local.all_domains)
  zone_id  = data.aws_route53_zone.hosted_zone.id
  name     = each.value
  type     = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}