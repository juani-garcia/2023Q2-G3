output "route_table_id" {
  description = "ID of the created Route Table"
  value       = aws_route_table.my_route_table.id
}
