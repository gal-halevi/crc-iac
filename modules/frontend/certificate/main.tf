# Create a public certificate
resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = var.alternate_domains
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Environment = var.env
  }
}

# Validate the certificate
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in var.records_to_validate : record.fqdn]
}