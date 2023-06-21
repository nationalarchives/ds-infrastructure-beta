resource "aws_iam_policy" "deployment_s3" {
    name        = "deployment-source-s3-policy"
    description = "deployment S3 access"

    policy = templatefile("${module.root}/templates/deployment-source-s3-access", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        service              = var.service
    })
}

resource "aws_iam_policy" "rp_config_s3" {
    name        = "private-beta-rp-s3-policy"
    description = "S3 access to nginx configuration files and log files"

    policy = templatefile("${path.module}/templates/revers-proxy-s3-policy.json", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        logfile_s3_bucket    = var.logfile_s3_bucket,
        key                  = "private-beta/nginx"
    })
}
