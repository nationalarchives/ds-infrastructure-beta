## -----------------------------------------------------------------------------
## Environment Specific Variables

environment = "live"
region      = "eu-west-2"
service     = "beta"

internal_domain_name = "beta.staging.local"
ciim_domain_name     = "ciim.staging.local"

deployment_s3_bucket  = "ds-live-deployment-source"
logfile_s3_bucket     = "ds-live-logfiles"

rp_deployment_s3_root = "beta/reverse-proxy"
rp_logfile_s3_root    = "beta/reverse-proxy"

on_prem_cidrs = [
    "172.31.2.0/24",
    "172.31.6.0/24",
    "172.31.10.0/24"
]
