resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc-id

  tags = {
    Name = var.name
    Created_by = var.created-by
  }
}
