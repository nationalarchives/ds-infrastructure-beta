# -----------------------------------------------------------------------------
# Autoscaling group
# -----------------------------------------------------------------------------
resource "aws_autoscaling_group" "private_beta" {
    name                 = "private-beta-dw-asg"
    launch_configuration = aws_launch_configuration.private_beta.name

    vpc_zone_identifier = [
        var.private_subnet_a_id,
        var.private_subnet_b_id
    ]

    max_size                  = var.dw_asg_max_size
    min_size                  = var.dw_asg_min_size
    desired_capacity          = var.dw_asg_desired_capacity
    health_check_grace_period = var.dw_asg_health_check_grace_period
    health_check_type         = var.dw_asg_health_check_type

    enabled_metrics = [
        "GroupMinSize",
        "GroupMaxSize",
        "GroupDesiredCapacity",
        "GroupInServiceInstances",
        "GroupTotalInstances"
    ]

    metrics_granularity = "1Minute"

    lifecycle {
        create_before_destroy = true
        ignore_changes        = [
            load_balancers,
            target_group_arns
        ]
    }

    dynamic "tag" {
        for_each = var.dw_asg_tags
        content {
            key                 = tag.value["key"]
            value               = tag.value["value"]
            propagate_at_launch = tag.value["propagate_at_launch"]
        }
    }
}

resource "aws_autoscaling_attachment" "private_beta" {
    autoscaling_group_name = aws_autoscaling_group.private_beta.id
    lb_target_group_arn    = aws_lb_target_group.private_beta_dw.arn
}

resource "aws_autoscaling_policy" "private_beta_up_policy" {
    name                   = "private-beta-dw-up-policy"
    scaling_adjustment     = 1
    adjustment_type        = "ChangeInCapacity"
    cooldown               = 300
    autoscaling_group_name = aws_autoscaling_group.private_beta.name
}

resource "aws_autoscaling_policy" "private_beta_down_policy" {
    name                   = "private-beta-dw-down-policy"
    scaling_adjustment     = -1
    adjustment_type        = "ChangeInCapacity"
    cooldown               = 300
    autoscaling_group_name = aws_autoscaling_group.private_beta.name
}
