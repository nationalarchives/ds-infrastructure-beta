# -----------------------------------------------------------------------------
# Launch Template
# -----------------------------------------------------------------------------
resource "aws_launch_template" "reverse_proxy" {
    name = "private-beta-rp"

    iam_instance_profile {
        arn = var.profile_arn
    }

    image_id               = var.image_id
    instance_type          = var.instance_type
    key_name               = var.key_name
    update_default_version = true

    vpc_security_group_ids = [
        var.sg_id
    ]

    user_data = base64encode(templatefile("${path.module}/scripts/userdata.sh", {
        service              = "private-beta",
        mount_target         = var.efs_dns_name,
        mount_dir            = var.efs_mount_dir,
        deployment_s3_bucket = var.deployment_s3_bucket,
        nginx_folder_s3_key  = var.nginx_folder_s3_key
    }))
    block_device_mappings {
        device_name = "/dev/xvda"

        ebs {
            volume_size = var.root_block_device_size
            encrypted   = true
        }
    }
}
