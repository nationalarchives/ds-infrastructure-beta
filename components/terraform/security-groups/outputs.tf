output "dw_lb_sg_id" {
    value = aws_security_group.dw_lb.id
}
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
output "upload_efs_sg_id" {
    value = aws_security_group.upload_efs.id
}
output "lambda_beta_deployment_id" {
    value = aws_security_group.lambda_beta_deployment.id
}
