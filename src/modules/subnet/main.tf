# resource "aws_vpc" "my_vpc" {
#   cidr_block           = var.vpc_cidr
#   enable_dns_support   = true
#   enable_dns_hostnames = true

#   tags = {
#     Name = var.vpc_name
#   }
# }

resource "aws_subnet" "subnet" {
  count             = length(var.subnet_names)
  cidr_block        = cidrsubnet(var.vpc_cidr, var.newbits, count.index + var.starting_cidr)
  availability_zone = var.az
  vpc_id            = var.vpc_id

  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = var.subnet_names[count.index]
  }
}

# resource "aws_subnet" "private_subnet_1" {
#   vpc_id    = aws_vpc.my_vpc.id
#   cidr_block = "${cidrsubnet(var.vpc_cidr, 8, 2)}"
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = "Private Subnet 1"
#   }
# }
