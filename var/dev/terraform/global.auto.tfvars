## -----------------------------------------------------------------------------
## Environment Specific Variables

environment = "dev"
region      = "eu-west-2"
service     = "private-beta"

public_domain_name   = "private-beta.nationalarchives.gov.uk"
internal_domain_name = "private-beta.dev.local"
ciim_domain_name     = "ciim.dev.local"

deployment_s3_bucket = "ds-dev-deployment-source"
logfile_s3_bucket    = "ds-dev-logfiles"

on_prem_cidrs = [
  "172.31.2.0/24",
  "172.31.6.0/24",
  "172.31.10.0/24"
]
