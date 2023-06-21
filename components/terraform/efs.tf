variable "rp_efs_backup_schedule" {}
variable "rp_efs_backup_start_window" {}
variable "rp_efs_backup_completion_window" {}
variable "rp_efs_backup_cold_storage_after" {}
variable "rp_efs_backup_delete_after" {}
variable "rp_efs_backup_kms_key_arn" {}

variable "dw_efs_backup_schedule" {}
variable "dw_efs_backup_start_window" {}
variable "dw_efs_backup_completion_window" {}
variable "dw_efs_backup_cold_storage_after" {}
variable "dw_efs_backup_delete_after" {}
variable "dw_efs_backup_kms_key_arn" {}

module "efs" {
    source = "./efs"

    private_subnet_a_id = data.aws_ssm_parameter.private_db_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_db_subnet_2b_id.value

    rp_efs_sg_id                     = module.sgs.rp_efs_sg_id
    rp_efs_backup_role_arn           = module.roles.rp_efs_backup_arn
    rp_efs_backup_schedule           = var.rp_efs_backup_schedule
    rp_efs_backup_start_window       = var.rp_efs_backup_start_window
    rp_efs_backup_completion_window  = var.rp_efs_backup_completion_window
    rp_efs_backup_cold_storage_after = var.rp_efs_backup_cold_storage_after
    rp_efs_backup_delete_after       = var.rp_efs_backup_delete_after
    rp_efs_backup_kms_key_arn        = var.rp_efs_backup_kms_key_arn

    dw_efs_sg_id                     = module.sgs.dw_efs_sg_id
    dw_efs_backup_role_arn           = module.roles.dw_efs_backup_arn
    dw_efs_backup_schedule           = var.dw_efs_backup_schedule
    dw_efs_backup_start_window       = var.dw_efs_backup_start_window
    dw_efs_backup_completion_window  = var.dw_efs_backup_completion_window
    dw_efs_backup_cold_storage_after = var.dw_efs_backup_cold_storage_after
    dw_efs_backup_delete_after       = var.dw_efs_backup_delete_after
    dw_efs_backup_kms_key_arn        = var.dw_efs_backup_kms_key_arn

    tags = local.tags
}
