resource "aws_route_table" "this" {
  vpc_id = var.vpc_id
}

resource "aws_route_table_association" "this" {
  count          = length(var.subnet_ids)
  route_table_id = aws_route_table.this.id
  subnet_id      = var.subnet_ids[count.index]
}