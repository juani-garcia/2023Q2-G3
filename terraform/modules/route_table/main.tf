resource "aws_route_table" "this" {
  vpc_id = var.vpc_id
}

resource "aws_route_table_association" "this" {
  count          = length(var.subnet_ids)
  route_table_id = aws_route_table.this.id
  subnet_id      = var.subnet_ids[count.index]
}

resource "aws_route" "this" {
  route_table_id         = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.gateway_id
  nat_gateway_id         = var.public ? var.nat_gateway_id : null
}