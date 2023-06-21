lc_key_name      = "private-beta-dw-dev-eu-west-2"
lc_instance_type = "t3a.small"

dw_patch_group_name = "private-beta-dw-patchgroup"
dw_deployment_group = "private-beta-dw-deploygroup"
dw_auto_switch_on   = true
dw_auto_switch_off  = true

dw_asg_max_size                  = 1
dw_asg_min_size                  = 1
dw_asg_desired_capacity          = 1
dw_asg_health_check_grace_period = 150
dw_asg_health_check_type         = "EC2"
