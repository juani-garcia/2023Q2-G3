resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

module "public_subnet" {
  source = "../subnet"
  count  = length(var.azs)

  vpc_cidr                = aws_vpc.this.cidr_block
  vpc_id                  = aws_vpc.this.id
  az                      = var.azs[count.index]
  newbits                 = var.newbits
  starting_cidr           = count.index
  subnet_name             = var.public_subnet_names[count.index]
  map_public_ip_on_launch = true
}

module "private_subnet" {
  source = "../subnet"
  count  = length(var.azs)

  vpc_cidr                = aws_vpc.this.cidr_block
  vpc_id                  = aws_vpc.this.id
  az                      = var.azs[count.index]
  newbits                 = var.newbits
  starting_cidr           = count.index + length(var.public_subnet_names)
  subnet_name             = var.private_subnet_names[count.index]
  map_public_ip_on_launch = false
}
