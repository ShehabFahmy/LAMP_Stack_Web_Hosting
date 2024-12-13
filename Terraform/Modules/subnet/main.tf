resource "aws_subnet" "subnet" {
  vpc_id     = var.vpc-id
  cidr_block = var.name-and-cidr[1]
  availability_zone = var.availability-zone
  # map_public_ip_on_launch = true

  tags = {
    Name       = var.name-and-cidr[0],
    Created_by = var.created-by
  }
}