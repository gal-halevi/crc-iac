# Get a previously created hosted zone
data "aws_route53_zone" "hosted_zone" {
  name         = var.domain_name
  private_zone = false
}

# Add certificate records to the hosted zone
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in var.domain_validation_options : dvo.domain_name => {
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

# Create Route 53 alias record pointing to CloudFront
resource "aws_route53_record" "cf_alias" {
  for_each = toset(var.domain_list)
  zone_id  = data.aws_route53_zone.hosted_zone.id
  name     = each.value
  type     = "A"

  alias {
    name                   = var.cloudfront_domain
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}