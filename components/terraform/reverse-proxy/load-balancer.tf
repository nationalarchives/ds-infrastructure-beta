# -----------------------------------------------------------------------------
# Public Load Balancer
# -----------------------------------------------------------------------------
resource "aws_lb" "rp_public" {
    name               = "private-beta-rp-lb"
    internal           = false
    load_balancer_type = "application"

    security_groups = [
        var.rp_lb_sg_id
    ]

    subnets = [
        var.public_subnet_a_id,
        var.public_subnet_b_id
    ]

    tags = var.tags
}

resource "aws_lb_target_group" "rp_public" {
    name     = "private-beta-rp"
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
        matcher             = "200"
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
