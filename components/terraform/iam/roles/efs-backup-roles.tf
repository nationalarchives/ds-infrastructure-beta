resource "aws_iam_role" "media_efs_backup" {
    name = "beta-media-efs-backup-role"

    assume_role_policy  = file("${path.root}/templates/efs_backup_assume_role.json")
}

resource "aws_iam_role_policy_attachment" "media_efs_backup_policy_attachment" {
    role       = aws_iam_role.media_efs_backup.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}
