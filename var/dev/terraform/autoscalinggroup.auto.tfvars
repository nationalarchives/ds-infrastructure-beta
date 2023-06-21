rp_nginx_patch_group      = "private-beta-rp-patchgroup"
rp_nginx_deployment_group = "private-beta-rp-deploygroup"

rp_asg_max_size                  = 2
rp_asg_min_size                  = 1
rp_asg_desired_capacity          = 1
rp_asg_health_check_grace_period = 150
rp_asg_health_check_type         = "EC2"

dw_patch_group_name = "private-beta-dw-patchgroup"
dw_deployment_group = "private-beta-dw-deploygroup"

dw_asg_max_size                  = 2
dw_asg_min_size                  = 1
dw_asg_desired_capacity          = 1
dw_asg_health_check_grace_period = 150
dw_asg_health_check_type         = "EC2"
