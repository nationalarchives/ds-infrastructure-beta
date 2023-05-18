## -----------------------------------------------------------------------------
## locals

locals {
    tags = {
        Terraform   = "true"
        Product     = "private beta"
        Environment = var.environment
        CostCentre  = "53"
        Owner       = "Digital Services"
        Region      = "eu-west-2"
    }
}

## -----------------------------------------------------------------------------
## environment variables

variable "environment" {}
