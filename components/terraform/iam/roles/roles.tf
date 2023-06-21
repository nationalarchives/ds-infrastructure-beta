resource "aws_iam_role" "efs_backup" {
    name               = "private-beta-dw-efs-backup-role"
    assume_role_policy = file("${module.root}/templates/efs_backup_assume_role.json")

    managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
    ]
}

resource "aws_iam_role" "dw_role" {
    name               = "private-beta-dw-assume-role"
    assume_role_policy = file("${module.root}/templates/ec2_assume_role.json")

    managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
        "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
        var.deployment_s3_policy,
    ]
}

resource "aws_iam_instance_profile" "dw_profile" {
resource "aws_iam_instance_profile" "dw_profile" {
    name = "private-beta-dw-iam-instance-profile"
    path = "/"
    role = aws_iam_role.dw_role
}
