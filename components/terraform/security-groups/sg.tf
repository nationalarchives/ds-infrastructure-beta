# -----------------------------------------------------------------------------
# application servers Django/Wagtail
# -----------------------------------------------------------------------------
# load balancer
#
resource "aws_security_group" "dw_lb" {
    name        = "private-beta-dw-lb"
    description = "Reverse Proxy Security Group HTTP access"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "private-beta-dw-lb"
    })
}

resource "aws_security_group_rule" "dw_lb_http_ingress" {
    cidr_blocks       = var.dw_lb_cidr
    description = "port 80 traffic from RPs"
    from_port         = 80
    protocol          = "tcp"
    security_group_id = aws_security_group.rp.id
    to_port           = 80
    type              = "ingress"
}

resource "aws_security_group_rule" "dw_lb_http_egress" {
    security_group_id = aws_security_group.rp_lb.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}

# instance
#
resource "aws_security_group" "dw" {
    name        = "private-beta-dw"
    description = "access to application"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "private-beta-dw"
    })
}

resource "aws_security_group_rule" "dw_http_ingress" {
    description              = "port 80 traffic from LB"
    from_port                = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.dw.id
    source_security_group_id = aws_security_group.dw_lb.id
    to_port                  = 80
    type                     = "ingress"
}

resource "aws_security_group_rule" "dw_response_ingress" {
    cidr_blocks       = var.dw_instance_cidr
    description       = "traffic from Client-VPN and load balancer"
    from_port         = 1024
    protocol          = "tcp"
    security_group_id = aws_security_group.dw.id
    to_port           = 65535
    type              = "ingress"
}

resource "aws_security_group_rule" "dw_http_egress" {
    security_group_id = aws_security_group.dw.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}

# EFS access
#
resource "aws_security_group" "dw_efs" {
    name        = "private-beta-dw-efs-access"
    description = "access to EFS storage"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "private-beta-dw-efs-access"
    })
}

resource "aws_security_group_rule" "dw_efs_ingress" {
    from_port                = 0
    protocol                 = "tcp"
    security_group_id        = aws_security_group.dw_efs.id
    to_port                  = 65535
    type                     = "ingress"
    source_security_group_id = aws_security_group.dw_efs.id
}

resource "aws_security_group_rule" "efs_egress" {
    cidr_blocks = [
        "0.0.0.0/0"
    ]
    security_group_id = aws_security_group.dw_efs.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
}
# -----------------------------------------------------------------------------
# reverse proxy
# -----------------------------------------------------------------------------
# load balancer
#
resource "aws_security_group" "rp_lb" {
    name        = "private-beta-rp-lb"
    description = "reverse proxy HTTP and HTTPS access"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "private-beta-rp-lb"
    })
}

resource "aws_security_group_rule" "rp_lb_http_ingress" {
    cidr_blocks       = ["0.0.0.0/0"]
    description       = "port 80 will be redirected to 443"
    from_port         = 80
    protocol          = "tcp"
    security_group_id = aws_security_group.rp_lb.id
    to_port           = 443
    type              = "ingress"
}

resource "aws_security_group_rule" "rp_lb_https_ingress" {
    cidr_blocks       = ["0.0.0.0/0"]
    description       = "443 traffic from anywhere"
    from_port         = 443
    protocol          = "tcp"
    security_group_id = aws_security_group.rp_lb.id
    to_port           = 443
    type              = "ingress"
}

resource "aws_security_group_rule" "rp_lb_http_egress" {
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.rp_lb.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
}

# instance
#
resource "aws_security_group" "rp" {
    name        = "private-beta-rp"
    description = "Reverse proxy security group"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "private-beta-rp"
    })
}

resource "aws_security_group_rule" "rp_http_ingress" {
    description              = "port 80 traffic from LB"
    from_port                = 80
    to_port                  = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.rp.id
    source_security_group_id = aws_security_group.rp_lb.id
    type                     = "ingress"
}

resource "aws_security_group_rule" "rp_response_ingress" {
    cidr_blocks       = var.rp_instance_cidr
    description = "allow response from internal subnets"
    from_port         = 1024
    to_port           = 65535
    protocol          = "tcp"
    security_group_id = aws_security_group.rp.id
    type              = "ingress"
}

resource "aws_security_group_rule" "rp_egress" {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    security_group_id = aws_security_group.rp.id
    type              = "egress"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}

# Security group reverse proxy EFS
#
resource "aws_security_group" "rp_efs" {
    name        = "private-beta-rp-efs-sg"
    description = "Reverse proxy EFS storage security group"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "private-beta-rp-efs-sg"
    })
}

resource "aws_security_group_rule" "rp_efs_ingress" {
    from_port                = 0
    protocol                 = "tcp"
    security_group_id        = aws_security_group.rp_efs.id
    to_port                  = 65535
    type                     = "ingress"
    source_security_group_id = aws_security_group.rp.id
}

resource "aws_security_group_rule" "rp_efs_egress" {
    security_group_id = aws_security_group.rp_efs.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}

resource "aws_vpc_security_group_ingress_rule" "rp_efs_http" {
    security_group_id = aws_security_group.rp_efs.id

    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 0
    ip_protocol = "tcp"
    to_port     = 65535
}

resource "aws_security_group" "rp_lc" {
    name        = "private-beta-rp-lc-sg"
    description = "reverse proxy security group"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "private-beta-rp-sg"
    })
}

resource "aws_vpc_security_group_ingress_rule" "rp_lc_http" {
    security_group_id = aws_security_group.rp_lc.id

    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 80
    ip_protocol = "tcp"
    to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "rp_lc_https" {
    security_group_id = aws_security_group.rp_lc.id

    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 1024
    ip_protocol = "tcp"
    to_port     = 65535
}

# lambda - deployment
#
resource "aws_security_group" "lambda_private_beta_deployment" {
    name        = "lambda-private-beta-deployment-sg"
    description = "lambda private beta deployment security group"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "lambda-private-beta-deployment-sg"
    })
}

resource "aws_vpc_security_group_ingress_rule" "lambda_private_beta_deployment" {
    security_group_id = aws_security_group.lambda_private_beta_deployment.id

    cidr_ipv4   = "10.128.224.0/23"
    from_port   = 1024
    ip_protocol = "tcp"
    to_port     = 65535
}

resource "aws_security_group_rule" "lambda_private_beta_egress_443" {
    security_group_id = aws_security_group.lambda_private_beta_deployment.id
    type              = "egress"
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}

resource "aws_security_group_rule" "lambda_private_beta_egress_general" {
    security_group_id = aws_security_group.lambda_private_beta_deployment.id
    type              = "egress"
    from_port         = 1024
    to_port           = 65535
    protocol          = "tcp"
    cidr_blocks       = [
        "10.128.224.0/23"
    ]
}
