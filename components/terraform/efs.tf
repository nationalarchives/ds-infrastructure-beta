variable "upload_efs_backup_schedule" {}
variable "upload_efs_backup_start_window" {}
variable "upload_efs_backup_completion_window" {}
variable "upload_efs_backup_cold_storage_after" {}
variable "upload_efs_backup_delete_after" {}
variable "upload_efs_backup_kms_key_arn" {}

module "efs" {
    source = "./efs"

    private_subnet_a_id = data.aws_ssm_parameter.private_db_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_db_subnet_2b_id.value

    upload_efs_sg_id                     = module.sgs.upload_efs_sg_id
    upload_efs_backup_role_arn           = module.roles.upload_efs_backup_arn
    upload_efs_backup_schedule           = var.upload_efs_backup_schedule
    upload_efs_backup_start_window       = var.upload_efs_backup_start_window
    upload_efs_backup_completion_window  = var.upload_efs_backup_completion_window
    upload_efs_backup_cold_storage_after = var.upload_efs_backup_cold_storage_after
    upload_efs_backup_delete_after       = var.upload_efs_backup_delete_after
    upload_efs_backup_kms_key_arn        = var.upload_efs_backup_kms_key_arn

    tags = local.tags
}
