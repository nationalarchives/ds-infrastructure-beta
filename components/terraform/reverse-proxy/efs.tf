# -----------------------------------------------------------------------------
# EFS storage
# -----------------------------------------------------------------------------

resource "aws_security_group" "rp_efs" {
    name        = "private-beta-efs-reverse-proxy-sg"
    description = "Reverse proxy EFS storage security group"
    vpc_id      = var.vpc_id

    ingress {
        description = "allow connection from instances"
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = [
            var.vpc_cidr
        ]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
    }

    tags = merge(var.tags, {
        Name = "private-beta-efs-reverse-proxy-sg"
    })
}

resource "aws_iam_role" "efs_backup" {
    name = "private-beta-reverse-proxy-efs-backup-role"

    assume_role_policy  = file("${path.root}/templates/efs_backup_assume_role")
    managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
    ]

    tags = var.tags
}

resource "aws_efs_file_system" "rp_efs" {
    creation_token = "private-beta-efs-reverse-proxy"
    encrypted      = true

    tags = var.tags
}

resource "aws_efs_mount_target" "rp_efs_private_a" {
    file_system_id = aws_efs_file_system.rp_efs.id
    subnet_id      = var.private_subnet_a_id

    security_groups = [
        aws_security_group.rp_efs.id
    ]
}

resource "aws_efs_mount_target" "rp_efs_private_b" {
    file_system_id = aws_efs_file_system.rp_efs.id
    subnet_id      = var.private_subnet_b_id

    security_groups = [
        aws_security_group.rp_efs.id
    ]
}

resource "aws_backup_selection" "efs_backup" {
    name         = "private-beta-reverse-proxy-efs-backup"
    plan_id      = aws_backup_plan.efs_backup.id
    iam_role_arn = aws_iam_role.efs_backup.arn

    resources = [
        aws_efs_file_system.rp_efs.arn
    ]
}

resource "aws_backup_plan" "efs_backup" {
    name = "private-beta-reverse-proxy-efs-backup-plan"

    rule {
        rule_name         = "private-beta-efs-backup-rule"
        target_vault_name = aws_backup_vault.efs_backup.name
        schedule          = var.rp_efs_backup_schedule
        start_window      = var.rp_efs_backup_start_window
        completion_window = var.rp_efs_backup_completion_window
        lifecycle {
            cold_storage_after = var.rp_efs_backup_cold_storage_after
            delete_after       = var.rp_efs_backup_delete_after
        }
    }

    tags = var.tags
}

resource "aws_backup_vault" "efs_backup" {
    name        = "private-beta-reverse-proxy-efs-backup-vault"
    kms_key_arn = var.rp_efs_backup_kms_key_arn

    tags = var.tags
}
