output "cloudfront_dns" {
  value = aws_cloudfront_distribution.private_beta.domain_name
}

output "cloudfront_zone_id" {
  value = aws_cloudfront_distribution.private_beta.hosted_zone_id
}
