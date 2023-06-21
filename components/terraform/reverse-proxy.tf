locals {
    rp_asg_tags = [
        {
            key                 = "Name"
            value               = "private-beta-reverse-proxy-nginx"
            propagate_at_launch = "true"
        },
        {
            key                 = "Service"
            value               = "private-beta"
            propagate_at_launch = "true"
        },
        {
            key                 = "Owner"
            value               = local.tags.Owner
            propagate_at_launch = "true"
        },
        {
            key                 = "CostCentre"
            value               = local.tags.CostCentre
            propagate_at_launch = "true"
        },
        {
            key                 = "Terraform"
            value               = "true"
            propagate_at_launch = "true"
        },
        {
            key                 = "Patch Group"
            value               = var.rp_nginx_patch_group
            propagate_at_launch = "true"
        },
        {
            key                 = "Deployment-Group"
            value               = var.rp_nginx_deployment_group
            propagate_at_launch = "true"
        },
        {
            key                 = "AutoSwitchOn"
            value               = "true"
            propagate_at_launch = "true"
        },
        {
            key                 = "AutoSwitchOff"
            value               = "true"
            propagate_at_launch = "true"
        },
    ]

}

# reverse proxy
#
variable "rp_nginx_patch_group" {}
variable "rp_nginx_deployment_group" {}

variable "rp_instance_type" {}
variable "rp_key_name" {}
variable "rp_efs_mount_dir" {}
variable "rp_nginx_folder_s3_key" {}

variable "rp_root_block_device_size" {}

# auto-scaling
#
variable "rp_asg_max_size" {}
variable "rp_asg_min_size" {}
variable "rp_asg_desired_capacity" {}
variable "rp_asg_health_check_grace_period" {}
variable "rp_asg_health_check_type" {}

module "reverse-proxy" {
    source = "./reverse-proxy"

    # networking
    #
    vpc_id              = data.aws_ssm_parameter.vpc_id
    vpc_cidr            = data.aws_ssm_parameter.vpc_cidr
    public_subnet_a_id  = data.aws_ssm_parameter.public_subnet_2a_id
    public_subnet_b_id  = data.aws_ssm_parameter.public_subnet_2b_id
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id

    rp_lb_sg_id               = module.sgs.rp_lb_sg_id
    rp_profile_name           = module.roles.rp_profile_name
    rp_efs_dns_name           = module.efs.rp_efs_dns_name
    rp_lc_sg_id = module.sgs.rp_sg_id
    # launch configuration
    #
    rp_image_id               = data.aws_ami.private_beta_rp_ami.id
    rp_instance_type          = var.rp_instance_type
    rp_key_name               = var.rp_key_name
    rp_root_block_device_size = var.rp_root_block_device_size
    rp_efs_mount_dir          = var.rp_efs_mount_dir
    rp_nginx_folder_s3_key    = var.rp_nginx_folder_s3_key

    # auto-scaling
    #
    rp_asg_max_size                  = var.rp_asg_max_size
    rp_asg_min_size                  = var.rp_asg_min_size
    rp_asg_desired_capacity          = var.rp_asg_desired_capacity
    rp_asg_health_check_grace_period = var.rp_asg_health_check_grace_period
    rp_asg_health_check_type         = var.rp_asg_health_check_type

    rp_asg_tags = local.rp_asg_tags

    deployment_s3_bucket = var.deployment_s3_bucket
    logfile_s3_bucket    = var.logfile_s3_bucket

    # certificates
    #
    ssl_cert_arn = data.aws_ssm_parameter.wildcard_certificate_arn

    public_domain_name = lookup(local.cf_dist, "cfd_origin_id", "")

    tags = merge(local.tags, {
        service = "private-beta-reverse-proxy"
    })
}
