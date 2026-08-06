output "rp_profile_name" {
    value = aws_iam_instance_profile.rp_profile.name
}
output "rp_profile_arn" {
    value = aws_iam_instance_profile.rp_profile.arn
}

output "media_efs_backup_arn" {
    value = aws_iam_role.media_efs_backup.arn
}

output "rp_role_id" {
    value = aws_iam_role.rp_role.arn
}
