resource "aws_iam_role" "media_efs_backup" {
    name = "beta-media-efs-backup-role"

    assume_role_policy  = file("${path.root}/templates/efs_backup_assume_role.json")
    managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
    ]
}
