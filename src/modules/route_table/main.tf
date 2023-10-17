resource "aws_route_table" "my_route_table" {
  vpc_id = var.vpc_id
}

resource "aws_route_table_association" "my_route_table_association" {
  count          = length(var.subnet_ids)
  route_table_id = aws_route_table.my_route_table.id
  subnet_id      = var.subnet_ids[count.index]
}

resource "aws_route" "my_route" {
  route_table_id         = aws_route_table.my_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.gateway_id
  nat_gateway_id         = var.public ? var.nat_gateway_id : null
}