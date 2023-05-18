## -----------------------------------------------------------------------------
## networking

data "aws_ssm_parameter" "vpc_id" {
    name = "/infrastructure/vpc_id"
}

data "aws_ssm_parameter" "vpc_cidr" {
    name = "/infrastructure/vpc_cidr"
}

data "aws_ssm_parameter" "public_subnet_2a_id" {
    name = "/infrastructure/public_subnet_2a_id"
}

data "aws_ssm_parameter" "public_subnet_2b_id" {
    name = "/infrastructure/public_subnet_2b_id"
}

data "aws_ssm_parameter" "private_subnet_2a_id" {
    name = "/infrastructure/private_subnet_2a_id"
}

data "aws_ssm_parameter" "private_subnet_2b_id" {
    name = "/infrastructure/private_subnet_2b_id"
}

## -----------------------------------------------------------------------------
## amis

data "aws_ami" "website_ami" {
    most_recent = true

    filter {
        name   = "name"
        values = [
            "website-wp-primer-${var.environment}*"
        ]
    }

    filter {
        name   = "virtualization-type"
        values = [
            "hvm"
        ]
    }

    owners = [
        data.aws_caller_identity.current.account_id,
        "amazon"
    ]
}

data "aws_ami" "rp_ami" {
    most_recent = true

    filter {
        name   = "name"
        values = [
            "website-rp-primer-${var.environment}*"
        ]
    }

    filter {
        name   = "virtualization-type"
        values = [
            "hvm"
        ]
    }

    owners = [
        data.aws_caller_identity.current.account_id,
        "amazon"
    ]
}

data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "zone_id" {
    name = "/infrastructure/zone_id"
}

data "aws_secretsmanager_secret" "wp" {
    arn = var.wp_secretsmanager_secret_arn
}

data "aws_secretsmanager_secret_version" "wp" {
    secret_id = data.aws_secretsmanager_secret.wp.id
}

data "aws_ssm_parameter" "sns_slack_alert" {
    name = "/infrastructure/sns_slack_alert_arn"
}

## -----------------------------------------------------------------------------
## certificates

data "aws_ssm_parameter" "wildcard_certificate_arn" {
    name = "/infrastructure/certificate-manager/wildcard-certificate-arn"
}

data "aws_ssm_parameter" "us_east_1_wildcard_certificate_arn" {
    name = "/infrastructure/certificate-manager/us-east-1-wildcard-certificate-arn"
}

## -----------------------------------------------------------------------------
## DB Security Group

data "aws_ssm_parameter" "web_db_sg_id" {
    name = "/infrastructure/web_db_sg_id"
}

# codedeploy
# ----------------
data "aws_ssm_parameter" "s3_deployment_source_arn" {
    name = "/infrastructure/s3/deployment_source_arn"
}
