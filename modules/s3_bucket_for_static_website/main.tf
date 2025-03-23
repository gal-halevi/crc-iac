# Create S3 bucket for static website hosting
resource "aws_s3_bucket" "s3-bucket" {
  bucket = "${var.bucket_name}-${var.env}"

  tags = {
    Environment = var.env
  }
}

resource "aws_s3_object" "frontend_config" {
  bucket       = aws_s3_bucket.s3-bucket.id
  key          = "config.json"
  source       = "${var.web_assets_path}/config.json" # TODO: need to fix this hardcoded value inside module
  content_type = "application/json"
}

# Upload website files
resource "aws_s3_object" "website_assets" {
  bucket       = aws_s3_bucket.s3-bucket.id
  for_each     = toset([for file in fileset(var.web_assets_path, "**/*") : file if !startswith(file, ".")])
  source       = "${var.web_assets_path}/${each.value}"
  key          = each.value
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), "application/octet-stream")
}

# Add policy to S3 bucket for allowing CloudFront to use it
resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.s3-bucket.id
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Id      = "PolicyForCloudFrontPrivateContent"
      Statement = [
        {
          Sid    = "AllowCloudFrontServicePrincipal"
          Effect = "Allow"
          Principal = {
            Service = "cloudfront.amazonaws.com"
          }
          Action   = "s3:GetObject"
          Resource = "${aws_s3_bucket.s3-bucket.arn}/*"
          Condition = {
            StringEquals = {
              "AWS:SourceArn" = var.cloudfront_distribution_arn
            }
          }
        }
      ]
    }
  )
}