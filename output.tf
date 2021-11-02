output "Controller_PublicIP" {
  value = aws_instance.remo-avi-controller[*].public_ip
}
output "Controller_PrivateIP" {
  value = aws_instance.remo-avi-controller[*].private_ip
}
