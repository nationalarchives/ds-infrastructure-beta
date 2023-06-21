variable "public_domain" {}
variable "private_record" {}
variable "db_record" {}

resource "aws_route53_zone" "public_domain" {
    name = var.public_domain

    tags = merge(local.tags, {
        "Created_By" = "KK"
    })
}

# -----------------------------------------------------------------------------
# Private zone CNAME record for Django/Wagtail load balancer
# -----------------------------------------------------------------------------
resource "aws_route53_record" "app" {
    zone_id = data.aws_ssm_parameter.zone_id
    name    = "private-beta.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        module.django-wagtail.lb_internal_dns_name
    ]
}

