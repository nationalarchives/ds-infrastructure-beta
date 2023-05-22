variable "web_acl_default_action_allow" {}
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

module "waf" {
    providers = {
        aws.aws-cf-waf = aws.aws-cf-waf
    }

    source = "./waf"

    web_acl_default_action_allow = var.web_acl_default_action_allow
    site_ips                     = split(",", data.aws_ssm_parameter.private_beta_waf_ipset)
    tags                         = local.tags

    web_acl_requests_in_5_minutes            = var.web_acl_requests_in_5_minutes
    web_acl_shield_advanced_active           = var.web_acl_shield_advanced_active
    web_acl_amazon_ip_reputation_list        = var.web_acl_amazon_ip_reputation_list
    web_acl_managed_rules_linux_rule_set     = var.web_acl_managed_rules_linux_rule_set
    web_acl_managed_rules_php_rule_set       = var.web_acl_managed_rules_php_rule_set
    web_acl_managed_rules_wordpress_rule_set = var.web_acl_managed_rules_wordpress_rule_set
}
