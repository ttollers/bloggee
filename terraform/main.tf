locals {
  sld_name = replace(var.domain_name, "/.[a-z]*$/", "")
}

data "aws_s3_bucket" "root" {
  bucket = local.sld_name
}

resource "aws_s3_bucket" "www" {
  bucket = "www.${local.sld_name}"
  acl    = "public-read"
  website {
    redirect_all_requests_to = "https://${var.domain_name}"
  }
}

module "root_domain" {
  source = "./modules/cloudfront"
  bucket_website_domain = data.aws_s3_bucket.root.website_endpoint
  acm_cert = aws_acm_certificate.cert.arn
  aliases = [var.domain_name]
}

module "www_redirect" {
  source = "./modules/cloudfront"
  bucket_website_domain = aws_s3_bucket.www.website_endpoint
  acm_cert = aws_acm_certificate.cert.arn
  aliases = ["www.${var.domain_name}"]
}
