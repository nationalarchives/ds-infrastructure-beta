# -----------------------------------------------------------------------------
# Launch config
# -----------------------------------------------------------------------------
resource "aws_launch_configuration" "website" {
    name_prefix          = "private-beta-app"
    image_id             = var.lc_ami_id
    instance_type        = var.lc_instance_type
    iam_instance_profile = var.lc_instance_profile
    key_name             = var.lc_key_name

    user_data = templatefile("${path.root}/scripts/userdata.sh", {
        mount_target = aws_efs_file_system.website.dns_name
        mount_dir    = var.efs_mount_dir
    })

    security_groups = [
        var.lc_sg_id,
    ]

    root_block_device {
        volume_size = 100
        encrypted   = true
    }

    lifecycle {
        create_before_destroy = true
    }
}
