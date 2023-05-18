terraform {
    required_version = ">= 1.2.9"

    required_providers {
        aws = "4.67.0"
    }
}

provider "aws" {
    alias  = "aws-cf-waf"
    region = "us-east-1"
}

provider "aws" {
    region  = "eu-west-2"
    alias   = "intersite"

    assume_role {
        role_arn = "arn:aws:iam::500447081210:role/github-actions-xacct"
    }
}

provider "aws" {
    region  = "eu-west-2"
    alias   = "environment"
}

# this provider is used for command line to  suppress input for region
provider "aws" {
    region  = "eu-west-2"
}
