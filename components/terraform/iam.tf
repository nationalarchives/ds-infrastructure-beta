module "policies" {
    source = "./iam/policies"

    deployment_s3_bucket = var.deployment_s3_bucket
    service = var.service

    logfile_s3_bucket = var.logfile_s3_bucket
}

module "roles" {
    source = "./iam/roles"

    deployment_s3_policy = module.policies.deployment_s3_policy_arn

    rp_config_s3_policy_arn = module.policies.rp_config_s3_policy_arn

    tags = local.tags
}
