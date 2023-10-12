# roles and profiles for Django/Wagtail
#
resource "aws_iam_role" "dw_efs_backup" {
    name = "private-beta-dw-efs-backup-role"

    assume_role_policy  = file("${path.root}/templates/efs_backup_assume_role.json")
    managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
    ]
}

resource "aws_iam_role" "dw_role" {
    name               = "private-beta-dw-assume-role"
    assume_role_policy = file("${path.root}/templates/ec2_assume_role.json")

    managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
        "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
        var.deployment_s3_policy,
    ]
}

resource "aws_iam_instance_profile" "dw_profile" {
    name = "private-beta-dw-profile"
    path = "/"
    role = aws_iam_role.dw_role.name
}

# roles and profiles for reverse proxy
resource "aws_iam_role" "rp_efs_backup" {
    name = "private-beta-rp-efs-backup-role"

    assume_role_policy  = file("${path.root}/templates/efs_backup_assume_role.json")
    managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
    ]

    tags = var.tags
}

resource "aws_iam_role" "rp_role" {
    name               = "private-beta-rp-role"
    assume_role_policy = file("${path.root}/templates/ec2_assume_role.json")

    managed_policy_arns = [
        var.rp_config_s3_policy_arn,
        "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
    ]
}

resource "aws_iam_instance_profile" "rp_profile" {
    name = "private-beta-rp-profile"
    role = aws_iam_role.rp_role.name
}

resource "aws_iam_role" "lambda_private_beta_docker_deployment_role" {
    name               = "lambda-private-beta-docker-deployment-role"
    assume_role_policy = file("${path.root}/templates/assume-role-lambda-policy.json")

    managed_policy_arns = [
        "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
        var.lambda_private_beta_docker_deployment_policy_arn
    ]

    description = "allow lambda to call script on instances"

    tags = var.tags
}
