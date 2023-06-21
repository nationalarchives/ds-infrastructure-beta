output "dw_app_id" {
    value = aws_security_group.dw_app.id
}
output "dw_efs_id" {
    value = aws_security_group.dw_efs.id
}
output "rp_id" {
    value = aws_security_group.rp.id
}
