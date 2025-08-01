# python version for klayers need updating when the python version for lambda changes
data "klayers_package_latest_version" "boto3" {
    name   = "boto3"
    region = "eu-west-2"

    python_version = "3.12"
}

resource "aws_lambda_layer_version" "datetime" {
    layer_name = "datetime"

    s3_bucket = "ds-${var.environment}-deployment-source"
    s3_key    = "lambda/layers/datetime-5.2.zip"

    compatible_runtimes = [
        "python3.10",
        "python3.11",
        "python3.12",
    ]
}

module "beta_docker_deployment" {
    source = "./lambda"

    beta_docker_deployment_role_arn = module.roles.lambda_beta_docker_deployment_role_arn

    subnet_ids = [
        data.aws_ssm_parameter.private_subnet_2a_id.value,
        data.aws_ssm_parameter.private_subnet_2b_id.value,
    ]

    layers = [
        data.klayers_package_latest_version.boto3.arn,
        aws_lambda_layer_version.datetime.arn
    ]

    security_group_ids = [
        module.sgs.lambda_beta_deployment_id,
    ]

    environment = var.environment

    tags = local.tags
}
