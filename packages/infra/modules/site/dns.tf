data "aws_route53_zone" "primary" {
  name = var.r53_zone
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.primary.zone_id
}

resource "aws_route53_record" "a_record" {
  zone_id = data.aws_route53_zone.primary.id
  name    = var.domain_name
  type    = "A"

  alias {
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    name                   = aws_cloudfront_distribution.cdn.domain_name
    evaluate_target_health = false
  }
}