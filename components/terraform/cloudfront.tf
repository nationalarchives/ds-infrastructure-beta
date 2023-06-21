locals {
    cf_dist = {
        "create_distribution"                            = true
        "cfd_domain_name"                                = ""
        "cfd_origin_id"                                  = "dev-private-beta.nationalarchives.gov.uk"
        "cfd_price_class"                                = "PriceClass_100"
        "cfd_enabled"                                    = true
        "cfd_aliases"                                    = ["dev-private-beta.nationalarchives.gov.uk"]
        "cfd_default_behaviour_allowed_methods"          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        "cfd_default_behaviour_cached_methods"           = ["GET", "HEAD"]
        "cfd_behaviour_default_viewer_protocol_policy"   = "redirect-to-https"
        "cfd_behaviour_viewer_protocol_policy"           = "redirect-to-https"
        "cfd_behaviour_compress"                         = true
        "cfd_cache_disabled_path_patterns"               = []
        "cfd_Managed_CachingOptimized_cache_policy_id"   = "2e54312d-136d-493c-8eb9-b001f22f67d2"
        "cfd_Managed_AllViewer_origin_request_policy_id" = "216adef6-5c7f-47e4-b989-5492eafa07d3"
        "cfd_Managed_CachingDisabled_cache_policy_id"    = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    }
}

## -----------------------------------------------------------------------------
## module variable definitions

## -----------------------------------------------------------------------------
##modules

module "cloudfront_public" {
    source = "./cloudfront"

    cf_dist = local.cf_dist

    website_waf_info         = module.waf.private_beta_waf_info
    wildcard_certificate_arn = data.aws_ssm_parameter.us_east_1_wildcard_certificate_arn.value

    tags = merge(local.tags, {
        service = "private-beta-cloudfront"
    })
}
