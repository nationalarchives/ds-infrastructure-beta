resource "aws_cloudfront_distribution" "private_beta" {
    origin {
        domain_name = var.lb_dns_name
        origin_id   = lookup(var.cf_dist, "cfd_origin_id", "")

          custom_origin_config {
            http_port              = 80
            https_port             = 443
            origin_protocol_policy = "https-only"
            origin_ssl_protocols   = ["TLSv1.2"]
          }
      }

    http_version = "http1.1"
    price_class = lookup(var.cf_dist, "cfd_price_class", "")
    enabled     = lookup(var.cf_dist, "cfd_enabled", "")

    aliases = lookup(var.cf_dist, "cfd_aliases", "")

    default_cache_behavior {
        target_origin_id = lookup(var.cf_dist, "cfd_origin_id", "")
        allowed_methods  = lookup(var.cf_dist, "cfd_default_behaviour_allowed_methods", "")
        cached_methods   = lookup(var.cf_dist, "cfd_default_behaviour_cached_methods", "")

        cache_policy_id          = lookup(var.cf_dist, "cfd_Managed_CachingOptimized_cache_policy_id", "")
        origin_request_policy_id = lookup(var.cf_dist, "cfd_Managed_AllViewer_origin_request_policy_id", "")

        viewer_protocol_policy = lookup(var.cf_dist, "cfd_behaviour_default_viewer_protocol_policy", "")
        compress               = lookup(var.cf_dist, "cfd_behaviour_compress", "")
    }

    # Managed Caching Disabled and Managed All Viewer policies
    dynamic "ordered_cache_behavior" {
        for_each = lookup(var.cf_dist, "cfd_cache_disabled_path_patterns", "")
        iterator = b
        content {
            path_pattern     = b.value
            target_origin_id = lookup(var.cf_dist, "cfd_origin_id", "")
            allowed_methods  = lookup(var.cf_dist, "cfd_default_behaviour_allowed_methods", "")
            cached_methods   = lookup(var.cf_dist, "cfd_default_behaviour_cached_methods", "")

            cache_policy_id          = lookup(var.cf_dist, "cfd_Managed_CachingDisabled_cache_policy_id", "")
            origin_request_policy_id = lookup(var.cf_dist, "cfd_Managed_AllViewer_origin_request_policy_id", "")

            viewer_protocol_policy = lookup(var.cf_dist, "cfd_behaviour_viewer_protocol_policy", "")
            compress               = lookup(var.cf_dist, "cfd_behaviour_compress", "")
        }
    }

    restrictions {
        geo_restriction {
          restriction_type = "none"
        }
    }

    tags = var.tags

    viewer_certificate {
        cloudfront_default_certificate = false
        acm_certificate_arn = var.wildcard_certificate_arn
        ssl_support_method  = "sni-only"
        minimum_protocol_version = "TLSv1.2_2021"
    }

    # get arn to indicate WAFv2
     web_acl_id = element(split(",", var.website_waf_info), 1)
}

## TODO
#  TTL values need to validated
resource "aws_cloudfront_cache_policy" "help_with_your_research" {
    name    = "help-with-your-research"
    comment = "include host to header and limit query strings"

    default_ttl = 300
    min_ttl     = 2
    max_ttl     = 3600

    parameters_in_cache_key_and_forwarded_to_origin {
        cookies_config {
            cookie_behavior = "none"
        }
        headers_config {
            header_behavior = "whitelist"
            headers {
                items = ["Host"]
            }
        }
        query_strings_config {
            query_string_behavior = "whitelist"
            query_strings {
                items = [
                    "research-category",
                    "letter"
                ]
            }
        }
        enable_accept_encoding_brotli = true
        enable_accept_encoding_gzip   = true
    }
}
