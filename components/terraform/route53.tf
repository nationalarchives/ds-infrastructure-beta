variable "private_record" {}
variable "db_record" {}

# Public domain name (reverse proxy) and alias to reverse proxy instance
#
resource "aws_route53_zone" "reverse_proxy_public" {
    name  = module.cloudfront_public.cloudfront_dns

    tags = local.tags
}

resource "aws_route53_record" "reverse_proxy_public" {
    zone_id = aws_route53_zone.reverse_proxy_public.zone_id
    name    = module.cloudfront_public.cloudfront_dns
    type    = "A"

    alias {
        name                   = module.cloudfront_public.cloudfront_dns
        zone_id                = module.cloudfront_public.cloudfront_zone_id
        evaluate_target_health = false
    }
}

# Private zone CNAME record for Django/Wagtail load balancer
#
resource "aws_route53_record" "app" {
    zone_id = data.aws_ssm_parameter.zone_id
    name    = "private-beta.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        module.django-wagtail.lb_internal_dns_name
    ]
}

