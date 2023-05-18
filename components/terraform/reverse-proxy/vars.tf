variable "vpc_id" {}
variable "vpc_cidr" {}
variable "private_subnet_a_id" {}
variable "private_subnet_b_id" {}

variable "rp_efs_backup_schedule" {}
variable "rp_efs_backup_start_window" {}
variable "rp_efs_backup_completion_window" {}
variable "rp_efs_backup_cold_storage_after" {}
variable "rp_efs_backup_delete_after" {}
variable "rp_efs_backup_kms_key_arn" {}

variable "tags" {}
