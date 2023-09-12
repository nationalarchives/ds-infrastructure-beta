resource "aws_iam_policy" "deployment_s3" {
    name        = "deployment-source-s3-policy"
    description = "deployment S3 access"

    policy = templatefile("${path.root}/templates/deployment-source-s3-access.json", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        service              = var.service
    })
}

resource "aws_iam_policy" "rp_config_s3" {
    name        = "private-beta-rp-s3-policy"
    description = "S3 access to nginx configuration files and log files"

    policy = templatefile("${path.root}/templates/reverse-proxy-s3-policy.json", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        logfile_s3_bucket    = var.logfile_s3_bucket,
        key                  = "private-beta/nginx"
    })
}

# private-beta-docker-deployment
#
resource "aws_iam_policy" "lambda_private_beta_docker_deployment_policy" {
    name        = "lambda-private-beta-docker-deployment-policy"
    description = "receive instance data and manipulate status"

    policy = templatefile("${path.root}/templates/lambda-private-beta-docker-deployment-policy.json", {
        account_id = var.account_id
    })
}

