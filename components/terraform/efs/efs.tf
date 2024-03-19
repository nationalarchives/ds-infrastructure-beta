# -----------------------------------------------------------------------------
# EFS storage
# -----------------------------------------------------------------------------
# upload efs
# shared between reverse proxy and frontend application server
#
resource "aws_efs_file_system" "upload_efs" {
    creation_token = "beta-upload-efs"
    encrypted      = true

    tags = var.tags
}

resource "aws_efs_mount_target" "upload_efs_private_a" {
    file_system_id = aws_efs_file_system.upload_efs.id
    subnet_id      = var.private_subnet_a_id

    security_groups = [
        var.upload_efs_sg_id
    ]
}

resource "aws_efs_mount_target" "upload_efs_private_b" {
    file_system_id = aws_efs_file_system.upload_efs.id
    subnet_id      = var.private_subnet_b_id

    security_groups = [
        var.upload_efs_sg_id
    ]
}

resource "aws_backup_selection" "upload_efs_backup" {
    name         = "beta-rp-efs-backup"
    plan_id      = aws_backup_plan.upload_efs_backup.id
    iam_role_arn = var.upload_efs_backup_role_arn

    resources = [
        aws_efs_file_system.upload_efs.arn
    ]
}

resource "aws_backup_plan" "upload_efs_backup" {
    name = "beta-upload-efs-backup-plan"

    rule {
        rule_name         = "beta-upload-efs-backup-rule"
        target_vault_name = aws_backup_vault.upload_efs_backup.name
        schedule          = var.upload_efs_backup_schedule
        start_window      = var.upload_efs_backup_start_window
        completion_window = var.upload_efs_backup_completion_window
        lifecycle {
            cold_storage_after = var.upload_efs_backup_cold_storage_after
            delete_after       = var.upload_efs_backup_delete_after
        }
    }

    tags = var.tags
}

resource "aws_backup_vault" "upload_efs_backup" {
    name        = "beta-upload-efs-backup-vault"
    kms_key_arn = var.upload_efs_backup_kms_key_arn

    tags = var.tags
}
