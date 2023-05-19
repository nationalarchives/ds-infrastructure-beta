# -----------------------------------------------------------------------------
# Public Load Balancer
# -----------------------------------------------------------------------------

resource "aws_security_group" "rp_lb" {
    name        = "private-beta-reverse-proxy-lb-sg"
    description = "Reverse Proxy Security Group HTTP and HTTPS access"
    vpc_id      = var.vpc_id

    tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.rp_lb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.rp_lb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "outwards_all" {
  security_group_id = aws_security_group.rp_lb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "-1"
  to_port     = 0
}

resource "aws_lb" "rp_public" {
    name               = "private-beta-reverse-proxy-lb"
    internal           = false
    load_balancer_type = "application"

    security_groups = [
        aws_security_group.rp_lb.id
    ]

    subnets = [
        var.public_subnet_a_id,
        var.public_subnet_b_id
    ]

    tags = var.tags
}

resource "aws_lb_target_group" "rp_public" {
    name     = "private-beta-reverse-proxy"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id

    health_check {
        interval            = 30
        path                = "/rp-beacon"
        port                = "traffic-port"
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200,301"
    }

    tags = var.tags
}

resource "aws_lb_listener" "public_http_lb_listener" {
    default_action {
        type = "redirect"
        redirect {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
        }
    }
    protocol          = "HTTP"
    load_balancer_arn = aws_lb.rp_public.arn
    port              = 80
}

resource "aws_lb_listener" "public_https_lb_listener" {
    default_action {
        target_group_arn = aws_lb_target_group.rp_public.arn
        type             = "forward"
    }

    protocol          = "HTTPS"
    load_balancer_arn = aws_lb.rp_public.arn
    port              = 443
    ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
    certificate_arn   = var.ssl_cert_arn
}
