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

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.resume-frontend-bucket.bucket_regional_domain_name
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  enabled             = true
  default_root_object = "index.html"
  is_ipv6_enabled     = true

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
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