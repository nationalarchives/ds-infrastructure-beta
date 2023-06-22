variable "resolver" {}

module "nginx_conf" {
    source = "./nginx-conf"

    service              = var.service
    deployment_s3_bucket = var.deployment_s3_bucket
    nginx_folder_s3_key  = "nginx"


    environment            = var.environment
    resolver               = var.resolver
}
