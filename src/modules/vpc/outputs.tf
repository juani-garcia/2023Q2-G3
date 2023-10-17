output "vpc_info" {
  description = "Information about the created VPC"
  value = {
    cidr_block      = aws_vpc.my_vpc.cidr_block
    vpc_id          = aws_vpc.my_vpc.id
    public_subnets  = module.public_subnet.*.subnet_info.ids[0] # This solves an array nesting problem I didn't have the time to look into
    private_subnets = module.private_subnet.*.subnet_info.ids[0]
  }
}