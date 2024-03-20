## -----------------------------------------------------------------------------
## locals

locals {
    tags = {
        Terraform   = "true"
        Product     = "beta"
        Environment = var.environment
        CostCentre  = "53"
        Owner       = "Digital Services"
        Region      = "eu-west-2"
    }
}

## -----------------------------------------------------------------------------
## variables - cross all modules

variable "environment" {}
variable "region" {}
variable "service" {}

variable "on_prem_cidrs" {}

variable "internal_domain_name" {}
variable "ciim_domain_name" {}

variable "deployment_s3_bucket" {}
variable "logfile_s3_bucket" {}

variable "rp_deployment_s3_root" {}
variable "rp_logfile_s3_root" {}
