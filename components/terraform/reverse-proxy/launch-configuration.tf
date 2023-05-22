resource "aws_security_group" "rp_lc" {
    name        = "private-beta-reverse-proxy-sg"
    description = "reverse proxy security group"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "private-beta-reverse-proxy-sg"
    })
}

resource "aws_vpc_security_group_ingress_rule" "http" {
    security_group_id = aws_security_group.rp_lc.id

    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 80
    ip_protocol = "tcp"
    to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "https" {
    security_group_id = aws_security_group.rp_lc.id

    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 1024
    ip_protocol = "tcp"
    to_port     = 65535
}

resource "aws_vpc_security_group_egress_rule" "outwards_all" {
    security_group_id = aws_security_group.rp_lc.id

    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 0
    ip_protocol = "-1"
    to_port     = 0
}

resource "aws_iam_policy" "rp_config_s3" {
    name        = "private-beta-reverse-proxy-s3-policy"
    description = "S3 access to nginx configuration files and log files"

    policy = templatefile("${path.root}/templates/revers-proxy-s3-policy.json", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        logfile_s3_bucket    = var.logfile_s3_bucket,
        key                  = "private-beta/nginx"
    })
}

resource "aws_iam_role" "rp_role" {
    name               = "private-beta-reverse-proxy-role"
    assume_role_policy = file("${path.root}/templates/ec2_assume_role.json")

    managed_policy_arns = [
        aws_iam_policy.rp_config_s3.arn,
        "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
    ]
}

resource "aws_iam_instance_profile" "rp_profile" {
    name = "private-beta-reverse-proxy-profile"
    path = "/"
    role = aws_iam_role.rp_role.name
}

resource "aws_launch_configuration" "rp" {
    name_prefix          = "private-beta-rp"
    image_id             = var.rp_image_id
    instance_type        = var.rp_instance_type
    iam_instance_profile = aws_iam_instance_profile.rp_profile.name
    key_name             = var.rp_key_name

    user_data = templatefile("${path.root}/scripts/userdata.sh", {
        service              = "private-beta",
        mount_target         = aws_efs_file_system.rp_efs.dns_name,
        mount_dir            = var.rp_efs_mount_dir,
        deployment_s3_bucket = var.deployment_s3_bucket,
        nginx_folder_s3_key  = var.rp_nginx_folder_s3_key
    })

    security_groups = [
        aws_security_group.rp_lc.id
    ]

    root_block_device {
        volume_size = var.rp_root_block_device_size
        encrypted   = true
    }

    lifecycle {
        create_before_destroy = true
    }
}
