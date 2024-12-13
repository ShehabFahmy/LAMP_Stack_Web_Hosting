output "id" {
  value = aws_key_pair.aws-key-pair.id
}

output "key-name" {
  value = aws_key_pair.aws-key-pair.key_name
}

output "private-key-path" {
  value = local_file.private_key.filename
}
