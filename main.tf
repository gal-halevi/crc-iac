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
  bucket = aws_s3_bucket.resume-frontend-bucket.id
  source = "../frontend/styles.css"
  key    = "styles.css"
  content_type = "text/css"
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.resume-frontend-bucket.id

  index_document {
    suffix = "index.html"
  }
}

# Make the bucket publicly accessible
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.resume-frontend-bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Attach a public bucket policy to allow website access
resource "aws_s3_bucket_policy" "public_read" {
  depends_on = [aws_s3_bucket_public_access_block.public_access]
  bucket     = aws_s3_bucket.resume-frontend-bucket.id
  policy     = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "${aws_s3_bucket.resume-frontend-bucket.arn}/*"
      ]
    }
  ]
}
POLICY
}