output "vpc_info" {
  description = "Information about the created VPC"
  value = {
    cidr_block         = aws_vpc.my_vpc.cidr_block
    vpc_id             = aws_vpc.my_vpc.id
    subnet_ids         = aws_subnet.public_subnet.*.id
    subnet_cidr_blocks = aws_subnet.public_subnet.*.cidr_block
  }
}