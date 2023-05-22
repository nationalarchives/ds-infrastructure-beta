# ===================================================================================================================
# Declare aliased providers
# ===================================================================================================================
terraform {
    required_providers {
        aws = {
            version               = ">= 4.67.0"
            source                = "hashicorp/aws"
            configuration_aliases = [
                aws.aws-cf-waf
            ]
        }
    }
}

# ===================================================================================================================
# VARIABLES
# ===================================================================================================================
variable "web_acl_default_action_allow" {
    description = "indicating the general waf behavior"
    default     = true
}

variable "web_acl_requests_in_5_minutes" {
    default = false
}

variable "web_acl_shield_advanced_active" {
    default = false
}

variable "web_acl_amazon_ip_reputation_list" {
    default = false
}

variable "web_acl_managed_rules_linux_rule_set" {
    default = false
}

variable "web_acl_managed_rules_php_rule_set" {
    default = false
}

variable "web_acl_managed_rules_wordpress_rule_set" {
    default = false
}

variable "site_ips" {
    description = "ip addresses opposing to general waf behaviour"
}

variable "tags" {}

# ===================================================================================================================
# RESOURCES
# ===================================================================================================================

resource "aws_wafv2_ip_set" "wp_website_access" {
    provider = aws.aws-cf-waf

    name               = "wp-website-access"
    description        = "IP set allowing access or blocking opposing main website"
    scope              = "CLOUDFRONT"
    ip_address_version = "IPV4"
    addresses          = var.site_ips

    tags = var.tags
}

resource "aws_wafv2_web_acl" "wp_website" {
    provider = aws.aws-cf-waf

    name  = "wp-website"
    scope = "CLOUDFRONT"

    default_action {
        dynamic "allow" {
            for_each = var.web_acl_default_action_allow == true ? [""] : []
            content {}
        }
        dynamic "block" {
            for_each = var.web_acl_default_action_allow == false ? [""] : []
            content {}
        }
    }

    rule {
        name     = "ip-address-access"
        priority = 0

        action {
            dynamic "allow" {
                for_each = var.web_acl_default_action_allow == false ? [""] : []
                content {}
            }
            dynamic "block" {
                for_each = var.web_acl_default_action_allow == true ? [""] : []
                content {}
            }
        }

        statement {
            ip_set_reference_statement {
                arn = aws_wafv2_ip_set.wp_website_access.arn
            }
        }

        visibility_config {
            cloudwatch_metrics_enabled = true
            metric_name                = "waf-ip-access-rule"
            sampled_requests_enabled   = true
        }
    }

    dynamic rule {
        for_each = var.web_acl_requests_in_5_minutes == true ? [""] : []
        content {
            name     = "requests-in-5-minutes"
            priority = 1

            action {
                block {}
            }

            statement {
                rate_based_statement {
                    limit              = 5000
                    aggregate_key_type = "IP"
                }
            }

            visibility_config {
                cloudwatch_metrics_enabled = true
                metric_name                = "requests-in-5-minutes"
                sampled_requests_enabled   = true
            }
        }
    }

    dynamic rule {
        for_each = var.web_acl_shield_advanced_active == true ? [""] : []
        content {
            name     = "ShieldMitigationRuleGroup_968803923593_ffdb120f-76b2-491e-8aa6-a1b557edb64c_f50c1afe-b7d3-459e-9f1e-d82a5f3c197d"
            priority = 2

            override_action {
                none {}
            }

            statement {
                rule_group_reference_statement {
                    arn = "arn:aws:wafv2:us-east-1:153427709519:global/rulegroup/ShieldMitigationRuleGroup_968803923593_ffdb120f-76b2-491e-8aa6-a1b557edb64c_f50c1afe-b7d3-459e-9f1e-d82a5f3c197d/432f1e08-34ed-49df-a6f7-01c9226e28c6"
                }
            }

            visibility_config {
                cloudwatch_metrics_enabled = true
                metric_name                = "ShieldMitigationRuleGroup_968803923593_ffdb120f-76b2-491e-8aa6-a1b557edb64c_f50c1afe-b7d3-459e-9f1e-d82a5f3c197d"
                sampled_requests_enabled   = false
            }
        }
    }

    rule {
        name     = "AWS-AWSManagedRulesBotControlRuleSet"
        priority = 3

        override_action {
            none {}
        }

        statement {
            managed_rule_group_statement {
                name        = "AWSManagedRulesBotControlRuleSet"
                vendor_name = "AWS"

                excluded_rule {
                    name = "CategoryMonitoring"
                }
                excluded_rule {
                    name = "CategoryAdvertising"
                }
                excluded_rule {
                    name = "CategoryArchiver"
                }
                excluded_rule {
                    name = "CategoryContentFetcher"
                }
                excluded_rule {
                    name = "CategoryEmailClient"
                }
                excluded_rule {
                    name = "CategoryHttpLibrary"
                }
                excluded_rule {
                    name = "CategoryLinkChecker"
                }
                excluded_rule {
                    name = "CategoryMiscellaneous"
                }
                excluded_rule {
                    name = "CategoryScrapingFramework"
                }
                excluded_rule {
                    name = "CategorySecurity"
                }
                excluded_rule {
                    name = "CategorySearchEngine"
                }
                excluded_rule {
                    name = "CategorySeo"
                }
                excluded_rule {
                    name = "CategorySocialMedia"
                }
                excluded_rule {
                    name = "SignalAutomatedBrowser"
                }
                excluded_rule {
                    name = "SignalKnownBotDataCenter"
                }
                excluded_rule {
                    name = "SignalNonBrowserUserAgent"
                }
            }
        }

        visibility_config {
            cloudwatch_metrics_enabled = true
            metric_name                = "AWS-AWSManagedRulesBotControlRuleSet"
            sampled_requests_enabled   = true
        }
    }

    dynamic rule {
        for_each = var.web_acl_amazon_ip_reputation_list == true ? [""] : []
        content {
            name     = "AWS-AWSManagedRulesAmazonIpReputationList"
            priority = 4

            override_action {
                none {}
            }


            statement {

                managed_rule_group_statement {
                    name        = "AWSManagedRulesAmazonIpReputationList"
                    vendor_name = "AWS"
                }
            }

            visibility_config {
                cloudwatch_metrics_enabled = true
                metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
                sampled_requests_enabled   = true

            }
        }
    }

    dynamic rule {
        for_each = var.web_acl_managed_rules_linux_rule_set == true ? [""] : []
        content {
            name     = "AWS-AWSManagedRulesLinuxRuleSet"
            priority = 5

            override_action {

                none {}
            }

            statement {

                managed_rule_group_statement {
                    name        = "AWSManagedRulesLinuxRuleSet"
                    vendor_name = "AWS"
                }
            }

            visibility_config {
                cloudwatch_metrics_enabled = true
                metric_name                = "AWS-AWSManagedRulesLinuxRuleSet"
                sampled_requests_enabled   = true

            }
        }
    }

    dynamic rule {
        for_each = var.web_acl_managed_rules_php_rule_set == true ? [""] : []
        content {
            name     = "AWS-AWSManagedRulesPHPRuleSet"
            priority = 7

            override_action {

                none {}
            }

            statement {

                managed_rule_group_statement {
                    name        = "AWSManagedRulesPHPRuleSet"
                    vendor_name = "AWS"
                }
            }

            visibility_config {
                cloudwatch_metrics_enabled = true
                metric_name                = "AWS-AWSManagedRulesPHPRuleSet"
                sampled_requests_enabled   = true
            }
        }
    }

    dynamic rule {
        for_each = var.web_acl_managed_rules_wordpress_rule_set == true ? [""] : []
        content {
            name     = "AWS-AWSManagedRulesWordPressRuleSet"
            priority = 8

            override_action {

                none {}
            }

            statement {

                managed_rule_group_statement {
                    name        = "AWSManagedRulesWordPressRuleSet"
                    vendor_name = "AWS"
                }
            }

            visibility_config {
                cloudwatch_metrics_enabled = true
                metric_name                = "AWS-AWSManagedRulesWordPressRuleSet"
                sampled_requests_enabled   = true
            }
        }
    }

    rule {
        name     = "AWSManagedRulesKnownBadInputsRuleSet"
        priority = 6

        override_action {
            none {}
        }


        statement {
            managed_rule_group_statement {
                name        = "AWSManagedRulesKnownBadInputsRuleSet"
                vendor_name = "AWS"
            }
        }

        visibility_config {
            cloudwatch_metrics_enabled = true
            metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
            sampled_requests_enabled   = true
        }
    }

    tags = var.tags

    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "aws-waf-logs-wp-website"
        sampled_requests_enabled   = true
    }
}

resource "aws_wafv2_regex_pattern_set" "wp_admin_url_pattern" {
    provider = aws.aws-cf-waf

    name        = "wp-admin-url-pattern"
    description = "pattern for website admin section"
    scope       = "CLOUDFRONT"

    regular_expression {
        regex_string = "^https:\\/\\/wp-admin/*"
    }

    tags = var.tags
}
