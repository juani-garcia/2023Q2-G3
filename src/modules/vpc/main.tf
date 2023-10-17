resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

# resource "aws_subnet" "subnet" {
#   count             = length(var.public_subnet_names)
#   cidr_block        = cidrsubnet("${aws_vpc.my_vpc.cidr_block}", var.newbits, count.index)
#   availability_zone = var.az
#   vpc_id            = aws_vpc.my_vpc.id

#   map_public_ip_on_launch = false

#   tags = {
#     Name = var.public_subnet_names[count.index]
#   }
# }

module "public_subnet" {
  source = "../subnet"

  vpc_cidr                = aws_vpc.my_vpc.cidr_block
  vpc_id                  = aws_vpc.my_vpc.id
  az                      = var.az
  newbits                 = var.newbits
  starting_cidr           = 0
  subnet_names            = var.public_subnet_names
  map_public_ip_on_launch = true
}

module "private_subnet" {
  source = "../subnet"

  vpc_cidr                = aws_vpc.my_vpc.cidr_block
  vpc_id                  = aws_vpc.my_vpc.id
  az                      = var.az
  newbits                 = var.newbits
  starting_cidr           = length(var.public_subnet_names)
  subnet_names            = var.private_subnet_names
  map_public_ip_on_launch = false
}

# resource "aws_subnet" "private_subnet_1" {
#   vpc_id    = aws_vpc.my_vpc.id
#   cidr_block = "${cidrsubnet(var.vpc_cidr, 8, 2)}"
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = "Private Subnet 1"
#   }
# }
