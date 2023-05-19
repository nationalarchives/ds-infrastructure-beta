locals {
    reverse_proxy_asg_tags = [
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
            value               = var.reverse_proxy_nginx_patch_group
            propagate_at_launch = "true"
        },
        {
            key                 = "Deployment-Group"
            value               = var.reverse_proxy_nginx_deployment_group
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

variable "reverse_proxy_nginx_patch_group" {}
variable "reverse_proxy_nginx_deployment_group" {}

variable "rp_efs_backup_schedule" {}
variable "rp_efs_backup_start_window" {}
variable "rp_efs_backup_completion_window" {}
variable "rp_efs_backup_cold_storage_after" {}
variable "rp_efs_backup_delete_after" {}
variable "rp_efs_backup_kms_key_arn" {}

variable "rp_instance_type" {}
variable "rp_key_name" {}
variable "rp_efs_mount_dir" {}
variable "rp_nginx_folder_s3_key" {}

variable "rp_root_block_device_size" {}

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

    # efs
    #
    rp_efs_backup_schedule           = var.rp_efs_backup_schedule
    rp_efs_backup_start_window       = var.rp_efs_backup_start_window
    rp_efs_backup_completion_window  = var.rp_efs_backup_completion_window
    rp_efs_backup_cold_storage_after = var.rp_efs_backup_cold_storage_after
    rp_efs_backup_delete_after       = var.rp_efs_backup_delete_after
    rp_efs_backup_kms_key_arn        = var.rp_efs_backup_kms_key_arn

    # launch configuration
    #
    rp_image_id               = data.aws_ami.private_beta_rp_ami.id
    rp_instance_type          = var.rp_instance_type
    rp_key_name               = var.rp_key_name
    rp_root_block_device_size = var.rp_root_block_device_size
    rp_efs_mount_dir          = var.rp_efs_mount_dir
    rp_nginx_folder_s3_key    = var.rp_nginx_folder_s3_key

    # certificates
    #
    ssl_cert_arn = data.aws_ssm_parameter.wildcard_certificate_arn

    public_domain_name = var.cloudfront_public_origin_id

    tags = merge(local.tags, {
        service = "reverse-proxy-private-beta"
    })
}
