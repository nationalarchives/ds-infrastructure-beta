variable "cf_dist" {}

## -----------------------------------------------------------------------------
##modules

module "cloudfront_public" {
    source = "./cloudfront"

    cf_dist = var.cf_dist

    lb_dns_name = module.reverse-proxy.reverse_proxy_lb_dns_name

    private_beta_waf_info         = module.waf.private_beta_waf_info
    wildcard_certificate_arn = data.aws_ssm_parameter.us_east_1_wildcard_certificate_arn.value

    tags = merge(local.tags, {
        service = "private-beta-cloudfront"
    })
}
