variable "vpc_id" {}
variable "vpc_cidr" {}
variable "public_subnet_a_id" {}
variable "public_subnet_b_id" {}
variable "private_subnet_a_id" {}
variable "private_subnet_b_id" {}

variable "rp_lb_sg_id" {}
variable "rp_profile_name" {}
variable "rp_efs_dns_name" {}
variable "rp_lc_sg_id" {}

# launch configuration - reverse proxy
#
variable "rp_image_id" {}
variable "rp_instance_type" {}
variable "rp_key_name" {}
variable "rp_root_block_device_size" {}
variable "rp_efs_mount_dir" {}
variable "rp_nginx_folder_s3_key" {}

# auto-scaling
#
variable "rp_asg_max_size" {}
variable "rp_asg_min_size" {}
variable "rp_asg_desired_capacity" {}
variable "rp_asg_health_check_grace_period" {}
variable "rp_asg_health_check_type" {}

variable "rp_asg_tags" {}

variable "deployment_s3_bucket" {}
variable "logfile_s3_bucket" {}

variable "ssl_cert_arn" {}

variable "tags" {}
