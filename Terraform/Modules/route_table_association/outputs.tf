output "ids" {
  value = [for assoc in aws_route_table_association.rtb-assoc : assoc.id]
}