output "cloudfront_domain_name" {
  value = module.root_domain.domain_name
}

output "s3_domaint_name" {
  value = data.aws_s3_bucket.root.website_endpoint
}
