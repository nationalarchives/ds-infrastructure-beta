# -----------------------------------------------------------------------------
# EFS storage
# -----------------------------------------------------------------------------
resource "aws_efs_file_system" "website" {
    creation_token = "private-beta-app-efs"

    tags = merge(var.tags, {
        Name = "private-beta-app-efs"
    })
}

resource "aws_efs_mount_target" "efs_private_a" {
    file_system_id  = aws_efs_file_system.website.id
    security_groups = [
        var.dw_efs_id
    ]
    subnet_id = var.private_subnet_a_id
}

resource "aws_efs_mount_target" "efs_private_b" {
    file_system_id  = aws_efs_file_system.website.id
    security_groups = [
        var.dw_efs_id
    ]
    subnet_id = var.private_subnet_b_id
}

resource "aws_backup_selection" "efs_backup" {
    name         = "private-beta-app-efs-backup"
    plan_id      = aws_backup_plan.efs_backup.id
    iam_role_arn = var.efs_backup_arn

    resources = [
        aws_efs_file_system.website.arn
    ]
}

resource "aws_backup_plan" "efs_backup" {
    name = "private-beta-app-efs-backup-plan"

    rule {
        rule_name         = "private-beta-app-efs-backup-rule"
        target_vault_name = aws_backup_vault.efs_backup.name
        schedule          = var.efs_backup_schedule
        start_window      = var.efs_backup_start_window
        completion_window = var.efs_backup_completion_window
        lifecycle {
            cold_storage_after = var.efs_backup_cold_storage_after
            delete_after       = var.efs_backup_delete_after
        }
    }

    tags = var.tags
}

resource "aws_backup_vault" "efs_backup" {
    name        = "private-beta-app-efs-backup-vault"
    kms_key_arn = var.efs_backup_kms_key_arn

    tags = var.tags
}
