# IAM Role for Reverse Proxy
resource "aws_iam_role" "rp_role" {
    name               = "beta-rp-role"
    assume_role_policy = file("${path.root}/templates/ec2_assume_role.json")
}

resource "aws_iam_role_policy_attachment" "rp_role_s3_policy" {
    role       = aws_iam_role.rp_role.name
    policy_arn = var.rp_config_s3_policy_arn
}

resource "aws_iam_role_policy_attachment" "rp_role_ssm_instance_core" {
    role       = aws_iam_role.rp_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# resource "aws_iam_role_policy_attachment" "rp_role_session_manager_logs" {
#     role       = aws_iam_role.rp_role.name
#     policy_arn = "arn:aws:iam::aws:policy/org-session-manager-logs"
# }


# resource "aws_iam_role_policy_attachment" "lambda_beta_docker_deployment_role_ssm_full_access" {
#     role       = aws_iam_role.lambda_beta_docker_deployment_role.name
#     policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
# }

resource "aws_iam_instance_profile" "rp_profile" {
  name = "beta-rp-profile"
  role = aws_iam_role.rp_role.name
}

