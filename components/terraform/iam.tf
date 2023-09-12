module "policies" {
    source = "./iam/policies"

    deployment_s3_bucket = var.deployment_s3_bucket
    service = var.service

    logfile_s3_bucket = var.logfile_s3_bucket

    account_id = data.aws_caller_identity.current.account_id
}

module "roles" {
    source = "./iam/roles"

    deployment_s3_policy = module.policies.deployment_s3_policy_arn

    rp_config_s3_policy_arn = module.policies.rp_config_s3_policy_arn

    lambda_private_beta_docker_deployment_policy_arn = module.policies.lambda_private_beta_docker_deployment_policy_arn

    tags = local.tags
}
