variable "lc_key_name" {}
variable "lc_instance_type" {}
variable "dw_patch_group_name" {}
variable "dw_deployment_group" {}
variable "dw_auto_switch_on" {}
variable "dw_auto_switch_off" {}

variable "dw_asg_max_size" {}
variable "dw_asg_min_size" {}
variable "dw_asg_desired_capacity" {}
variable "dw_asg_health_check_grace_period" {}
variable "dw_asg_health_check_type" {}

module "django-wagtail" {
    source = "./django-wagtail"

    vpc_id              = data.aws_ssm_parameter.vpc_id
    private_subnet_a_id = data.aws_ssm_parameter.private_db_subnet_2a_id
    private_subnet_b_id = data.aws_ssm_parameter.private_db_subnet_2b_id

    reverse_proxy_app_sg_id = module.sgs.rp_id
    dw_efs_id               = module.sgs.dw_efs_id

    lc_ami_id           = data.aws_ami.private_beta_ami.id
    lc_instance_type    = var.lc_instance_type
    lc_instance_profile = module.roles.dw_profile_name
    lc_key_name         = var.lc_key_name
    lc_sg_id            = module.sgs.dw_app_id

    efs_backup_arn = module.roles.dw_efs_backup_arn
    efs_mount_dir  = "/mnt/efs"

    patch_group_name = var.dw_patch_group_name
    deployment_group = var.dw_deployment_group
    auto_switch_on   = var.dw_auto_switch_on
    auto_switch_off  = var.dw_auto_switch_off

    dw_asg_min_size                  = var.dw_asg_min_size
    dw_asg_max_size                  = var.dw_asg_max_size
    dw_asg_desired_capacity          = var.dw_asg_desired_capacity
    dw_asg_health_check_grace_period = var.dw_asg_health_check_grace_period
    dw_asg_health_check_type         = var.dw_asg_health_check_type

    tags = local.tags
}
