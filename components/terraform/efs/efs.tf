# -----------------------------------------------------------------------------
# EFS storage
# -----------------------------------------------------------------------------
# reverse proxy efs
#
resource "aws_efs_file_system" "rp_efs" {
    creation_token = "private-beta-rp-efs"
    encrypted      = true

    tags = var.tags
}

resource "aws_efs_mount_target" "rp_efs_private_a" {
    file_system_id = aws_efs_file_system.rp_efs.id
    subnet_id      = var.private_subnet_a_id

    security_groups = [
        var.rp_efs_sg_id
    ]
}

resource "aws_efs_mount_target" "rp_efs_private_b" {
    file_system_id = aws_efs_file_system.rp_efs.id
    subnet_id      = var.private_subnet_b_id

    security_groups = [
        var.rp_efs_sg_id
    ]
}

resource "aws_backup_selection" "efs_backup" {
    name         = "private-beta-rp-efs-backup"
    plan_id      = aws_backup_plan.efs_backup.id
    iam_role_arn = var.rp_efs_backup_role_arn

    resources = [
        aws_efs_file_system.rp_efs.arn
    ]
}

resource "aws_backup_plan" "efs_backup" {
    name = "private-beta-rp-efs-backup-plan"

    rule {
        rule_name         = "private-beta-rp-efs-backup-rule"
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
    name        = "private-beta-rp-efs-backup-vault"
    kms_key_arn = var.rp_efs_backup_kms_key_arn

    tags = var.tags
}

# Django/Wagtail efs
#
resource "aws_efs_file_system" "dw_efs" {
    creation_token = "private-beta-dw-efs"

    tags = merge(var.tags, {
        Name = "private-beta-dw-efs"
    })
}

resource "aws_efs_mount_target" "efs_private_a" {
    file_system_id  = aws_efs_file_system.dw_efs.id
    security_groups = [
        var.dw_efs_sg_id
    ]
    subnet_id = var.private_subnet_a_id
}

resource "aws_efs_mount_target" "efs_private_b" {
    file_system_id  = aws_efs_file_system.dw_efs.id
    security_groups = [
        var.dw_efs_sg_id
    ]
    subnet_id = var.private_subnet_b_id
}

resource "aws_backup_selection" "efs_backup" {
    name         = "private-beta-dw-efs-backup"
    plan_id      = aws_backup_plan.efs_backup.id
    iam_role_arn = var.dw_efs_backup_role_arn

    resources = [
        aws_efs_file_system.dw_efs.arn
    ]
}

resource "aws_backup_plan" "efs_backup" {
    name = "private-beta-dw-efs-backup-plan"

    rule {
        rule_name         = "private-beta-dw-efs-backup-rule"
        target_vault_name = aws_backup_vault.efs_backup.name
        schedule          = var.dw_efs_backup_schedule
        start_window      = var.dw_efs_backup_start_window
        completion_window = var.dw_efs_backup_completion_window
        lifecycle {
            cold_storage_after = var.dw_efs_backup_cold_storage_after
            delete_after       = var.dw_efs_backup_delete_after
        }
    }

    tags = var.tags
}

resource "aws_backup_vault" "efs_backup" {
    name        = "private-beta-dw-efs-backup-vault"
    kms_key_arn = var.dw_efs_backup_kms_key_arn

    tags = var.tags
}
