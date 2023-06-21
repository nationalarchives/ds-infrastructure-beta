module "sgs" {
    source = "./security-groups"

    vpc_id = data.aws_ssm_parameter.vpc_id.value

    on_prem_cidrs = var.on_prem_cidrs

    tags = local.tags
}
