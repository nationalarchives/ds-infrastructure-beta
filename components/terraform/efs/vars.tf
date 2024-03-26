variable "private_subnet_a_id" {}
variable "private_subnet_b_id" {}

variable "media_efs_sg_ids" {}
variable "media_efs_backup_role_arn" {}

variable "media_efs_backup_schedule" {}
variable "media_efs_backup_start_window" {}
variable "media_efs_backup_completion_window" {}
variable "media_efs_backup_cold_storage_after" {}
variable "media_efs_backup_delete_after" {}
variable "media_efs_backup_kms_key_arn" {}

variable "tags" {}
