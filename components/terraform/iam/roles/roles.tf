# IAM Role for DW
resource "aws_iam_role" "dw_role" {
    name               = "beta-dw-assume-role"
    assume_role_policy = file("${path.root}/templates/ec2_assume_role.json")
}

resource "aws_iam_role_policy_attachment" "dw_role_policy_attachment" {
    role       = aws_iam_role.dw_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "dw_role_cloudwatch_agent" {
    role       = aws_iam_role.dw_role.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "dw_role_ssm_instance_core" {
    role       = aws_iam_role.dw_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# resource "aws_iam_role_policy_attachment" "dw_role_session_manager_logs" {
#     role       = aws_iam_role.dw_role.name
#     policy_arn = "arn:aws:iam::aws:policy/org-session-manager-logs"
# }

resource "aws_iam_role_policy_attachment" "dw_role_deployment_s3_policy" {
    role       = aws_iam_role.dw_role.name
    policy_arn = var.deployment_s3_policy
}

# IAM Instance Profile for DW
resource "aws_iam_instance_profile" "dw_profile" {
    name = "beta-dw-profile"
    path = "/"
    role = aws_iam_role.dw_role.name
}

# IAM Role for Reverse Proxy
resource "aws_iam_role" "rp_role" {
    name               = "beta-rp-role"
    assume_role_policy = file("${path.root}/templates/ec2_assume_role.json")
}

resource "aws_iam_role_policy_attachment" "rp_role_s3_policy" {
    role       = aws_iam_role.rp_role.name
    policy_arn = var.rp_config_s3_policy_arn
}

resource "aws_iam_role_policy_attachment" "rp_role_ec2_role_for_ssm" {
    role       = aws_iam_role.rp_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

# resource "aws_iam_role_policy_attachment" "rp_role_session_manager_logs" {
#     role       = aws_iam_role.rp_role.name
#     policy_arn = "arn:aws:iam::aws:policy/org-session-manager-logs"
# }

# IAM Role for Lambda Beta Docker Deployment
resource "aws_iam_role" "lambda_beta_docker_deployment_role" {
    name               = "lambda-beta-docker-deployment-role"
    assume_role_policy = file("${path.root}/templates/assume-role-lambda-policy.json")
    description        = "allow lambda to call script on instances"
    tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_beta_docker_deployment_role_ssm_full_access" {
    role       = aws_iam_role.lambda_beta_docker_deployment_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_beta_docker_deployment_role_custom_policy" {
    role       = aws_iam_role.lambda_beta_docker_deployment_role.name
    policy_arn = var.lambda_beta_docker_deployment_policy_arn
}
resource "aws_iam_instance_profile" "rp_profile" {
  name = "beta-rp-profile"
  role = aws_iam_role.rp_role.name
}

