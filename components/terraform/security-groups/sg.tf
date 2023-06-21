# -----------------------------------------------------------------------------
# application servers Django/Wagtail
# -----------------------------------------------------------------------------
resource "aws_security_group" "dw" {
    name        = "private-beta-app-sg"
    description = "access to application"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "private-beta-app-sg"
    })
}

resource "aws_security_group_rule" "dw_rp_http_ingress" {
    from_port                = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.dw.id
    to_port                  = 80
    type                     = "ingress"
    source_security_group_id = aws_security_group.rp.id
}

resource "aws_security_group_rule" "dw_http_ingress" {
    from_port                = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.dw.id
    to_port                  = 80
    type                     = "ingress"
    source_security_group_id = aws_security_group.dw.id
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

resource "aws_security_group_rule" "dw_rp_https_ingress" {
    from_port                = 443
    protocol                 = "tcp"
    security_group_id        = aws_security_group.dw.id
    to_port                  = 443
    type                     = "ingress"
    source_security_group_id = aws_security_group.rp.id
}

resource "aws_security_group_rule" "dw_https_ingress" {
    from_port                = 443
    protocol                 = "tcp"
    security_group_id        = aws_security_group.dw.id
    to_port                  = 443
    type                     = "ingress"
    source_security_group_id = aws_security_group.dw.id
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

resource "aws_security_group_rule" "efs_ingress" {
    from_port                = 0
    protocol                 = "tcp"
    security_group_id        = aws_security_group.dw_efs.id
    to_port                  = 65535
    type                     = "ingress"
    source_security_group_id = aws_security_group.dw_efs.id
}

resource "aws_security_group_rule" "efs_egress" {
    security_group_id = aws_security_group.dw_efs.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}
# -----------------------------------------------------------------------------
# reverse proxy
# -----------------------------------------------------------------------------
# Security Group public access (load balancer)
#
resource "aws_security_group" "rp_lb" {
    name        = "private-beta-rp-lb-sg"
    description = "Reverse Proxy Security Group HTTP and HTTPS access"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "private-beta-rp-lb-sg"
    })
}

resource "aws_security_group_rule" "rp_lb_http_ingress" {
    from_port         = 80
    protocol          = "tcp"
    security_group_id = aws_security_group.rp_lb.id
    to_port           = 80
    type              = "ingress"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}

resource "aws_security_group_rule" "rp_lb_http_egress" {
    security_group_id = aws_security_group.rp_lb.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}

resource "aws_security_group_rule" "rp_lb_https_ingress" {
    from_port         = 443
    protocol          = "tcp"
    security_group_id = aws_security_group.rp_lb.id
    to_port           = 443
    type              = "ingress"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}

# Security group reverse proxy instance
# - allowing ports 22, 53 and 80
#
resource "aws_security_group" "rp" {
    name        = "private-beta-reverse-proxy-sg"
    description = "Reverse proxy security group"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "private-beta-reverse-proxy-sg"
    })
}

resource "aws_security_group_rule" "rp_http_ingress" {
    from_port                = 80
    to_port                  = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.rp.id
    type                     = "ingress"
    source_security_group_id = aws_security_group.rp_lb.id
}

#resource "aws_security_group_rule" "rp_ssh_ingress" {
#    from_port                = 22
#    to_port                  = 22
#    protocol                 = "tcp"
#    security_group_id        = aws_security_group.rp.id
#    type                     = "ingress"
#    source_security_group_id = aws_security_group.rp_lb.id
#}
#
#resource "aws_security_group_rule" "rp_vpn_ingress" {
#    from_port         = 22
#    to_port           = 22
#    protocol          = "tcp"
#    security_group_id = aws_security_group.rp.id
#    type              = "ingress"
#    cidr_blocks       = [
#        var.vpn_cidr]
#}

resource "aws_security_group_rule" "rp_on_prem_ingress" {
    from_port         = 1024
    to_port           = 65535
    protocol          = "tcp"
    security_group_id = aws_security_group.rp.id
    type              = "ingress"
    cidr_blocks       = var.on_prem_cidrs
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
        Name = "private-beta-reverse-proxy-efs-sg"
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

resource "aws_vpc_security_group_egress_rule" "rp_efs_outwards_all" {
  security_group_id = aws_security_group.rp_efs.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "-1"
  to_port     = 0
}

resource "aws_security_group" "rp_lc" {
    name        = "private-beta-rp-lc-sg"
    description = "reverse proxy security group"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "private-beta-reverse-proxy-sg"
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

resource "aws_vpc_security_group_egress_rule" "rp_lc_outwards_all" {
    security_group_id = aws_security_group.rp_lc.id

    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 0
    ip_protocol = "-1"
    to_port     = 0
}
