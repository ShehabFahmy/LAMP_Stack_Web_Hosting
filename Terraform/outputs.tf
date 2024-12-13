output "ec2-public-dns" {
  value       = module.ec2-web-server.public-dns
  description = "Public DNS of the PHP web server EC2 instance."
}

output "web-server-dns" {
  value       = aws_route53_record.index-record.name
  description = "Domain name of the PHP web server."
}

output "route53-name-servers" {
  value       = aws_route53_zone.lamp-stack-route53-zone.name_servers
  description = "AWS Route53 name servers to be used on domain registrar."
}
