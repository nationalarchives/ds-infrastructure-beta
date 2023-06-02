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

resource "aws_autoscaling_group" "rp" {
    name                 = "private-beta-reverse-proxy-asg"
    launch_configuration = aws_launch_configuration.rp.name

    vpc_zone_identifier = [
        var.private_subnet_a_id,
        var.private_subnet_b_id
    ]

    max_size                  = var.rp_asg_max_size
    min_size                  = var.rp_asg_min_size
    desired_capacity          = var.rp_asg_desired_capacity
    health_check_grace_period = var.rp_asg_health_check_grace_period
    health_check_type         = var.rp_asg_health_check_type

    lifecycle {
        create_before_destroy = true
        ignore_changes        = [
            load_balancers,
            target_group_arns
        ]
    }

    dynamic "tag" {
        for_each = var.rp_asg_tags
        content {
            key                 = tag.value["key"]
            value               = tag.value["value"]
            propagate_at_launch = tag.value["propagate_at_launch"]
        }
    }
}

resource "aws_autoscaling_attachment" "rp" {
    autoscaling_group_name = aws_autoscaling_group.rp.id
    lb_target_group_arn    = aws_lb_target_group.rp_public.arn
}
