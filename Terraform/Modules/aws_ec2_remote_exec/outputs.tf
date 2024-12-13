output "id" {
  value = aws_instance.aws-linux-instance.id
}

output "public-ip" {
  value = aws_instance.aws-linux-instance.public_ip
}

output "public-dns" {
  value = aws_instance.aws-linux-instance.public_dns
}
