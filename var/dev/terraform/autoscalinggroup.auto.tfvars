rp_nginx_patch_group      = "linux-2-patch-group"
rp_nginx_deployment_group = "private-beta-nginx-rp-dg"

reverse_proxy_nginx_deployment_s3_bucket = "ds-dev-deployment-source"

rp_asg_max_size                  = 2
rp_asg_min_size                  = 1
rp_asg_desired_capacity          = 1
rp_asg_health_check_grace_period = 200
rp_asg_health_check_type         = "EC2"
