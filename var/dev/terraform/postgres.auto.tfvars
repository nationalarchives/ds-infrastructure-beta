instances = {
    source = {
        associate_public_ip_address = false
        availability_zone           = "a"
        iam_instance_profile        = "postgres-instance"
        instance_type               = "t3a.small"
        key_name                    = "postgres-source-wagtail-eu-west-2"
        monitoring                  = true
        root_block_device           = {
            delete_on_termination = true
            encrypted             = true
            volume_size           = 20
            volume_type           = "standard"
        }
        vpc_security_group_ids = [
            "wagtail-postgres"
        ]
    }
    replica = {
        associate_public_ip_address = false
        availability_zone           = "b"
        iam_instance_profile        = "postgres-instance"
        instance_type               = "t3a.small"
        key_name                    = "postgres-replica-wagtail-eu-west-2"
        monitoring                  = true
        root_block_device           = {
            delete_on_termination = true
            encrypted             = true
            volume_size           = 20
            volume_type           = "standard"
        }
        vpc_security_group_ids = [
            "wagtail-postgres"
        ]
    }
}
