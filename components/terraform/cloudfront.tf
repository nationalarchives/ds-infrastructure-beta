locals {
    cf_dist = {
        cfd_domain_name                                = module.reverse-proxy.reverse_proxy_lb_dns_name
        cfd_origin_id                                  = lookup(var.cf_dist, "cfd_origin_id", "")
        cfd_price_class                                = lookup(var.cf_dist, "cfd_price_class", "")
        cfd_enabled                                    = lookup(var.cf_dist, "cfd_enabled", "")
        cfd_aliases                                    = lookup(var.cf_dist, "cfd_aliases", "")
        cfd_default_behaviour_allowed_methods          = lookup(var.cf_dist, "cfd_default_behaviour_allowed_methods", [])
        cfd_default_behaviour_cached_methods           = lookup(var.cf_dist, "cfd_default_behaviour_cached_methods", [])
        cfd_behaviour_default_viewer_protocol_policy   = lookup(var.cf_dist, "cfd_behaviour_default_viewer_protocol_policy", "redirect-to-https")
        cfd_behaviour_viewer_protocol_policy           = lookup(var.cf_dist, "cfd_behaviour_viewer_protocol_policy", "redirect-to-https")
        cfd_behaviour_compress                         = lookup(var.cf_dist, "cfd_behaviour_compress", "")
        cfd_cache_disabled_path_patterns               = lookup(var.cf_dist, "cfd_cache_disabled_path_patterns", [])
        cfd_Managed_CachingOptimized_cache_policy_id   = lookup(var.cf_dist, "cfd_Managed_CachingOptimized_cache_policy_id", "")
        cfd_Managed_AllViewer_origin_request_policy_id = lookup(var.cf_dist, "cfd_Managed_AllViewer_origin_request_policy_id", "")
        cfd_Managed_CachingDisabled_cache_policy_id    = lookup(var.cf_dist, "cfd_Managed_CachingDisabled_cache_policy_id", "")
    }
}

## -----------------------------------------------------------------------------
## module variable definitions
variable "cf_dist" {}


variable "cloudfront_origin_id" {}
variable "cloudfront_domain_name" {}

## -----------------------------------------------------------------------------
##modules

module "cloudfront_public" {
    source = "./cloudfront"

    cf_dist = local.cf_dist

    website_waf_info         = module.waf.website_waf_info
    cloudfront_distributions = var.cf_dist
    wildcard_certificate_arn = data.aws_ssm_parameter.us_east_1_wildcard_certificate_arn.value

    tags = merge(local.tags, {
        service = "private-beta-cloudfront"
    })
}
