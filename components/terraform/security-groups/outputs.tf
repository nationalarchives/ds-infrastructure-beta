output "dw_sg_id" {
    value = aws_security_group.dw.id
}
output "dw_efs_sg_id" {
    value = aws_security_group.dw_efs.id
}

output "rp_sg_id" {
    value = aws_security_group.rp.id
}
output "rp_lb_sg_id" {
    value = aws_security_group.rp_lb.id
}
output "rp_efs_sg_id" {
    value = aws_security_group.rp_efs.id
}

