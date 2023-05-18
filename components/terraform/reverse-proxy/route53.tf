variable "public_domain_name" {}

# -----------------------------------------------------------------------------
# Public domain name (reverse proxy) and alias to reverse proxy instance

resource "aws_route53_zone" "reverse_proxy_public" {
    name  = var.public_domain_name

    tags = var.tags
}

resource "aws_route53_record" "reverse_proxy_public" {
    zone_id = aws_route53_zone.reverse_proxy_public.zone_id
    name    = var.public_domain_name
    type    = "A"

    alias {
        name                   = var.cloudfront_dns
        zone_id                = var.cloudfront_zone_id
        evaluate_target_health = false
    }
}
