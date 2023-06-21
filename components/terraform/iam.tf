module "policies" {
    source = "./iam/policies"

    deployment_s3_bucket = var.deployment_s3_bucket
    service = var.service
}

module "roles" {
    source = "./iam/roles"

    deployment_s3_policy = module.policies.deployment_s3_policy_arn
}
