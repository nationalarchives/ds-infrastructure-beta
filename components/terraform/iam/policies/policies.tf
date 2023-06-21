resource "aws_iam_policy" "deployment_s3" {
    name        = "deployment-source-s3-policy"
    description = "deployment S3 access"

    policy = templatefile("${module.root}/templates/deployment-source-s3-access", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        service              = var.service
    })
}
