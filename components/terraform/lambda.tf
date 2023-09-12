# python version for klayers need updating when the python version for lambda changes
data "klayers_package_latest_version" "boto3" {
    name   = "boto3"
    region = "eu-west-2"

    python_version = "3.11"
}

resource "aws_lambda_layer_version" "datetime" {
    layer_name = "datetime"

    s3_bucket = "ds-${var.environment}-deployment-source"
    s3_key    = "lambda/layers/datetime-5.2.zip"

    compatible_runtimes = [
        "python3.9",
        "python3.10",
        "python3.11",
    ]
}

module "private_beta_docker_deployment" {
    source = "./lambda/private-beta-docker-deployment"

}
