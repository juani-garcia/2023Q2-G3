resource "aws_subnet" "this" {
  cidr_block        = cidrsubnet(var.vpc_cidr, var.newbits, var.starting_cidr)
  availability_zone = var.az
  vpc_id            = var.vpc_id

  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = var.subnet_name
  }
}
