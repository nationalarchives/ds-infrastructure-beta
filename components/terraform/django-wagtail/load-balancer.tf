# -----------------------------------------------------------------------------
# Internal Load Balancer
# -----------------------------------------------------------------------------
resource "aws_lb" "private_beta_dw_lb" {
    name               = "private-beta-dw-lb"
    internal           = true
    load_balancer_type = "application"

    security_groups = [
        var.lc_sg_id
    ]

    subnets = [
        var.private_subnet_a_id,
        var.private_subnet_b_id
    ]

    tags = var.tags
}

resource "aws_lb_target_group" "private_beta_dw_tg" {
    name     = "private-beta-dw-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id

    health_check {
        interval            = 30
        path                = "/healthcheck.html"
        port                = "traffic-port"
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200"
    }

    tags = var.tags
}

resource "aws_lb_listener" "internal_http" {
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.private_beta_dw_tg.arn
    }
    protocol          = "HTTP"
    load_balancer_arn = aws_lb.private_beta_dw_lb.arn
    port              = 80
}
