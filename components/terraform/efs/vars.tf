variable "private_subnet_a_id" {}
variable "private_subnet_b_id" {}

variable "rp_efs_sg_id" {}
variable "rp_efs_backup_role_arn" {}

variable "rp_efs_backup_schedule" {}
variable "rp_efs_backup_start_window" {}
variable "rp_efs_backup_completion_window" {}
variable "rp_efs_backup_cold_storage_after" {}
variable "rp_efs_backup_delete_after" {}
variable "rp_efs_backup_kms_key_arn" {}

variable "dw_efs_sg_id" {}
variable "dw_efs_backup_role_arn" {}

variable "dw_efs_backup_schedule" {}
variable "dw_efs_backup_start_window" {}
variable "dw_efs_backup_completion_window" {}
variable "dw_efs_backup_cold_storage_after" {}
variable "dw_efs_backup_delete_after" {}
variable "dw_efs_backup_kms_key_arn" {}

variable "tags" {}
