
resource "aws_launch_configuration" "rp" {
    name_prefix          = "private-beta-rp"
    image_id             = var.rp_image_id
    instance_type        = var.rp_instance_type
    iam_instance_profile = var.rp_profile_name
    key_name             = var.rp_key_name

    user_data = templatefile("${path.root}/scripts/userdata.sh", {
        service              = "private-beta",
        mount_target         = var.rp_efs_dns_name,
        mount_dir            = var.rp_efs_mount_dir,
        deployment_s3_bucket = var.deployment_s3_bucket,
        nginx_folder_s3_key  = var.rp_nginx_folder_s3_key
    })

    security_groups = [
        var.rp_lc_sg_id
    ]

    root_block_device {
        volume_size = var.rp_root_block_device_size
        encrypted   = true
    }

    lifecycle {
        create_before_destroy = true
    }
}
