# -----------------------------------------------------------------------------
# EFS storage
# -----------------------------------------------------------------------------
# media efs
# shared between reverse proxy and frontend application server
#
resource "aws_efs_file_system" "media_efs" {
    creation_token = "beta-media-efs"
    encrypted      = true

    tags = merge(var.tags, {
        Name = "beta-media-efs"
    })
}

resource "aws_efs_mount_target" "media_efs_private_a" {
    file_system_id = aws_efs_file_system.media_efs.id
    subnet_id      = var.private_subnet_a_id

    security_groups = var.media_efs_sg_ids
}

resource "aws_efs_mount_target" "media_efs_private_b" {
    file_system_id = aws_efs_file_system.media_efs.id
    subnet_id      = var.private_subnet_b_id

    security_groups = var.media_efs_sg_ids
}

resource "aws_backup_selection" "media_efs_backup" {
    name         = "beta-media-efs-backup"
    plan_id      = aws_backup_plan.media_efs_backup.id
    iam_role_arn = var.media_efs_backup_role_arn

    resources = [
        aws_efs_file_system.media_efs.arn
    ]
}

resource "aws_backup_plan" "media_efs_backup" {
    name = "beta-media-efs-backup-plan"

    rule {
        rule_name         = "beta-media-efs-backup-rule"
        target_vault_name = aws_backup_vault.media_efs_backup.name
        schedule          = var.media_efs_backup_schedule
        start_window      = var.media_efs_backup_start_window
        completion_window = var.media_efs_backup_completion_window
        lifecycle {
            cold_storage_after = var.media_efs_backup_cold_storage_after
            delete_after       = var.media_efs_backup_delete_after
        }
    }

    tags = var.tags
}

resource "aws_backup_vault" "media_efs_backup" {
    name        = "beta-media-efs-backup-vault"
    kms_key_arn = var.media_efs_backup_kms_key_arn

    tags = var.tags
}
