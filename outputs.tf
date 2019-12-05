output instance_id {
  value = aws_instance.nodejs_instance.id
}

output instance_public_ipv4 {
  value = aws_instance.nodejs_instance.public_ip
}

output instance_public_dns {
  value = aws_instance.nodejs_instance.public_dns
}
