data "aws_route53_zone" "main" {
  name = "${var.domain_name}."
}

resource "aws_acm_certificate" "cert" {
  provider = aws.acm
  domain_name       = var.domain_name 
  subject_alternative_names = [
    "*.${var.domain_name}"
  ]
  validation_method = "DNS"
}

resource "aws_route53_record" "cert_validation" {
  provider = aws.acm
  name    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_type
  zone_id = data.aws_route53_zone.main.id
  records = [aws_acm_certificate.cert.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  provider = aws.acm
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}

resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.main.id
  name    = var.domain_name
  type    = "A"

  alias {
    name    = module.root_domain.domain_name
    zone_id = module.root_domain.hosted_zone_id
    evaluate_target_health = false
  }
}
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.main.id
  name    = "www"
  type    = "A"

  alias {
    name    = module.root_domain.domain_name
    zone_id = module.root_domain.hosted_zone_id
    evaluate_target_health = false
  }
}

#resource "aws_route53_record" "dev-root" {
  #zone_id = data.aws_route53_zone.main.id
  #name    = "dev"
  #type    = "A"

  #alias {
    #name    = module.root_domain.domain_name
    #zone_id = module.root_domain.hosted_zone_id
    #evaluate_target_health = false
  #}
#}

