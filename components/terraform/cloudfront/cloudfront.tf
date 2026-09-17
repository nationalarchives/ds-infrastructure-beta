resource "aws_cloudfront_distribution" "beta" {
    origin {
        domain_name = var.lb_dns_name
        origin_id   = lookup(var.cf_dist, "cfd_origin_id", "")

        custom_origin_config {
            http_port              = 80
            https_port             = 443
            origin_protocol_policy = "https-only"
            origin_ssl_protocols   = ["TLSv1.2"]
        }

        custom_header {
            name  = var.custom_header_name
            value = var.custom_header_value
        }
    }

    http_version = "http2"
    price_class  = lookup(var.cf_dist, "cfd_price_class", "")
    enabled      = lookup(var.cf_dist, "cfd_enabled", "")

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
        acm_certificate_arn            = var.wildcard_certificate_arn
        ssl_support_method             = "sni-only"
        minimum_protocol_version       = "TLSv1.2_2021"
    }

    # get arn to indicate WAFv2
    web_acl_id = element(split(",", var.beta_waf_info), 1)
}

resource "aws_cloudwatch_log_delivery_source" "beta" {
  region = "us-east-1"

  name         = "beta"
  log_type     = "ACCESS_LOGS"
  resource_arn = aws_cloudfront_distribution.beta.arn
}

resource "aws_cloudwatch_log_delivery_destination" "beta" {
  region = "us-east-1"

  name          = "s3-destination"
  output_format = "w3c"

  delivery_destination_configuration {
    destination_resource_arn = "arn:aws:s3:::ds-live-logfiles/beta/cloudfront/"
  }
}

resource "aws_cloudwatch_log_delivery" "beta" {
  region = "us-east-1"

  delivery_source_name     = aws_cloudwatch_log_delivery_source.beta.name
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.beta.arn
}