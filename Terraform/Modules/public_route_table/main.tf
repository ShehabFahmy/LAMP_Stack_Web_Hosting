resource "aws_route_table" "pb-rtb" {
  vpc_id = var.vpc-id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw-id
  }

  tags = {
    Name = var.name
    Created_by = var.created-by
  }
}
