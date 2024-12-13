resource "aws_vpc" "vpc" {
  cidr_block = var.cidr-block
  tags = {
    Name       = var.name,
    Created_by = var.created-by
  }
}
