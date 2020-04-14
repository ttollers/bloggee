resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.bucket_website_domain
    origin_id   = var.s3_origin_id
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = [
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2"
      ]
    }
  }

  aliases = var.aliases

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    acm_certificate_arn = var.acm_cert
    ssl_support_method = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }
}
