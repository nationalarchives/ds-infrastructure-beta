terraform {
    backend "s3" {
        bucket = "tna-terraform-backend-state-private-beta-eu-west-2-846769538626"
        key    = "ds-infrastructure-private-beta/dev.tfstate"
        region = "eu-west-2"
    }
}
