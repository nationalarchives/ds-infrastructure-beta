## -----------------------------------------------------------------------------
## module variable definitions

variable "cloudfront_public_origin_id" {}

## -----------------------------------------------------------------------------
##modules

module "cloudfront_public" {
    source = "./cloudfront"

    cloudfront_public_origin_id = var.cloudfront_public_origin_id
    cloudfront_public_domain_name = {loadbalancer-dns}

    website_waf_info         = module.waf.website_waf_info
    cloudfront_distributions = var.cloudfront_distributions
    wildcard_certificate_arn = data.aws_ssm_parameter.us_east_1_wildcard_certificate_arn.value

    tags = merge(local.tags, {
        service = "cloudfront-private-beta"
    })
}
