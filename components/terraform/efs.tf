variable "media_efs_backup_schedule" {}
variable "media_efs_backup_start_window" {}
variable "media_efs_backup_completion_window" {}
variable "media_efs_backup_cold_storage_after" {}
variable "media_efs_backup_delete_after" {}
variable "media_efs_backup_kms_key_arn" {}

module "efs" {
    source = "./efs"

    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value

    media_efs_sg_ids                     = [
        module.sgs.ec2_mount_efs_sg_id,
    ]
    media_efs_backup_role_arn           = module.roles.media_efs_backup_arn
    media_efs_backup_schedule           = var.media_efs_backup_schedule
    media_efs_backup_start_window       = var.media_efs_backup_start_window
    media_efs_backup_completion_window  = var.media_efs_backup_completion_window
    media_efs_backup_cold_storage_after = var.media_efs_backup_cold_storage_after
    media_efs_backup_delete_after       = var.media_efs_backup_delete_after
    media_efs_backup_kms_key_arn        = var.media_efs_backup_kms_key_arn

    tags = local.tags
}
