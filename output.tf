output "Controller_PublicIP" {
  value = aws_instance.remo-avi-controller[*].public_ip
}
