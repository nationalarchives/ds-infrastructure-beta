variable "vpc_id" {}
variable "private_subnet_a_id" {}
variable "private_subnet_b_id" {}

variable "dw_lb_sg_id" {}
variable "dw_efs_id" {}

variable "lc_efs_dns_name" {}
variable "lc_ami_id" {}
variable "lc_instance_type" {}
variable "lc_instance_profile" {}
variable "lc_key_name" {}
variable "lc_sg_id" {}

variable "efs_mount_dir" {}
variable "efs_dns_name" {}

variable "patch_group" {}
variable "deployment_group" {}
variable "auto_switch_on" {}
variable "auto_switch_off" {}

variable "dw_asg_max_size" {}
variable "dw_asg_min_size" {}
variable "dw_asg_desired_capacity" {}
variable "dw_asg_health_check_grace_period" {}
variable "dw_asg_health_check_type" {}

variable "dw_asg_tags" {}

variable "tags" {}
