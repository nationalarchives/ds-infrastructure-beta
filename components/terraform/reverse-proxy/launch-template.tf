# -----------------------------------------------------------------------------
# Launch Template
# -----------------------------------------------------------------------------
resource "aws_launch_template" "reverse_proxy" {
    name = "private-beta-rp"

    iam_instance_profile {
        arn = var.rp_profile_name
    }

    image_id               = var.rp_image_id
    instance_type          = var.rp_instance_type
    key_name               = var.rp_key_name
    update_default_version = true

    vpc_security_group_ids = [
        var.rp_lc_sg_id
    ]

    user_data = base64encode(templatefile("${path.module}/scripts/userdata.sh", {
        service              = "private-beta",
        mount_target         = var.rp_efs_dns_name,
        mount_dir            = var.rp_efs_mount_dir,
        deployment_s3_bucket = var.deployment_s3_bucket,
        nginx_folder_s3_key  = var.rp_nginx_folder_s3_key
    }))
    block_device_mappings {
        device_name = "/dev/xvda"

        ebs {
            volume_size = var.rp_root_block_device_size
            encrypted   = true
        }
    }
}
