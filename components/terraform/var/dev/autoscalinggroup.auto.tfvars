rp_nginx_patch_group      = "beta-rp-patchgroup"
rp_nginx_deployment_group = "beta-nginx-rp"

rp_asg_max_size                  = 2
rp_asg_min_size                  = 1
rp_asg_desired_capacity          = 1
rp_asg_health_check_grace_period = 150
rp_asg_health_check_type         = "EC2"
