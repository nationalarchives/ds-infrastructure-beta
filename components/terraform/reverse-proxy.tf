variable "rp_efs_backup_schedule" {}
variable "rp_efs_backup_start_window" {}
variable "rp_efs_backup_completion_window" {}
variable "rp_efs_backup_cold_storage_after" {}
variable "rp_efs_backup_delete_after" {}
variable "rp_efs_backup_kms_key_arn" {}

module "reverse-proxy" {
    source = "./reverse-proxy"

    vpc_id              = data.aws_ssm_parameter.vpc_id
    vpc_cidr            = data.aws_ssm_parameter.vpc_cidr
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id

    rp_efs_backup_schedule           = var.rp_efs_backup_schedule
    rp_efs_backup_start_window       = var.rp_efs_backup_start_window
    rp_efs_backup_completion_window  = var.rp_efs_backup_completion_window
    rp_efs_backup_cold_storage_after = var.rp_efs_backup_cold_storage_after
    rp_efs_backup_delete_after       = var.rp_efs_backup_delete_after
    rp_efs_backup_kms_key_arn        = var.rp_efs_backup_kms_key_arn

    public_domain_name = var.cloudfront_public_origin_id

    tags = merge(local.tags, {
        service = "reverse-proxy-private-beta"
    })
}
