resource "aws_iam_policy" "deployment_s3" {
    name        = "beta-deployment-source-s3-policy"
    description = "deployment S3 access for beta"

    policy = templatefile("${path.module}/templates/deployment-source-s3-access.json", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        service              = var.service
    })
}

resource "aws_iam_policy" "rp_config_s3" {
    name        = "beta-rp-s3-policy"
    description = "S3 access to nginx configuration files and log files"

    policy = templatefile("${path.module}/templates/instance-s3-policy.json", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        logfile_s3_bucket    = var.logfile_s3_bucket,
        deployment_root      = var.rp_deployment_s3_root,
        logfile_root         = var.rp_logfile_s3_root
    })
}

# beta-docker-deployment
#
resource "aws_iam_policy" "lambda_beta_docker_deployment_policy" {
    name        = "lambda-beta-docker-deployment-policy"
    description = "receive instance data and manipulate status"

    policy = templatefile("${path.module}/templates/lambda-beta-docker-deployment-policy.json", {
        account_id = var.account_id
    })
}

