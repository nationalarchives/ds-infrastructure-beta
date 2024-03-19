variable "private_subnet_a_id" {}
variable "private_subnet_b_id" {}

variable "upload_efs_sg_id" {}
variable "upload_efs_backup_role_arn" {}

variable "upload_efs_backup_schedule" {}
variable "upload_efs_backup_start_window" {}
variable "upload_efs_backup_completion_window" {}
variable "upload_efs_backup_cold_storage_after" {}
variable "upload_efs_backup_delete_after" {}
variable "upload_efs_backup_kms_key_arn" {}

variable "tags" {}
