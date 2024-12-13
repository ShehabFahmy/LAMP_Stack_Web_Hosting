# Apply the route table to a specific subnet
resource "aws_route_table_association" "rtb-assoc" {
  count = length(var.subnet-ids)
  subnet_id = var.subnet-ids[count.index]
  route_table_id = var.rtb-id
}
