# Create a Hosted Zone
resource "aws_route53_zone" "lamp-stack-route53-zone" {
  name = var.domain-name
}

# Associate a DNS Record to the PHP Web Server EC2 Instance's Public IP
resource "aws_route53_record" "index-record" {
  zone_id = aws_route53_zone.lamp-stack-route53-zone.zone_id
  name    = var.record-name
  type    = "A"
  # The TTL (Time-To-Live) is the duration (in seconds) that a DNS record is cached by a DNS resolver (like your ISP's DNS).
  # A lower TTL allows changes to propagate quickly, while a higher TTL reduces DNS query traffic but may delay updates.
  ttl     = "300"
  records = [module.ec2-web-server.public-ip]
}
