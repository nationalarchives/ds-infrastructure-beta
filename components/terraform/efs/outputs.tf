output "dw_efs_dns_name" {
    value = aws_efs_file_system.dw_efs.dns_name
}
output "rp_efs_dns_name" {
    value = aws_efs_file_system.rp_efs.dns_name
}
