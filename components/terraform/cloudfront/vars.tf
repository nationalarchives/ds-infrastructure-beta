## -----------------------------------------------------------------------------
## variable definitions

variable "cloudfront_public_domain_name" {}
variable "cloudfront_public_origin_id" {}

variable "wildcard_certificate_arn" {}

# ======================================================================================================================
# Variables
# ======================================================================================================================

variable "cloudfront_distributions" {
  description = "A map of details for a set of Cloudfront distributions"
  default     = {}
}

variable "website_waf_info" {
  description = "Taken from aws ssm parameter store data"
  default     = {}
}

variable "owner" {
  description = "Deployment Policy Assume role role account"
}

variable "environment" {
  description = "Deployment Policy Assume role role account"
}

variable "created_by" {
  description = "Deployment Policy Assume role role account"
}

variable "account" {
  description = "Deployment Policy Assume role role account"
}

variable "cost_centre" {
  description = "Cost centre 53 - ds"
}

# ======================================================================================================================
# Local Values - Sets Default Tags
# ======================================================================================================================

locals {
  default_tags = {
    Owner          = var.owner
    CostCentre     = var.cost_centre
    Environment    = var.environment
    Created_By     = var.created_by
    Region         = "eu-west-2"
    Account        = var.account
    Terraform      = "true"
  }
}
