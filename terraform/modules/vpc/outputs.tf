output "cidr" {
  description = "CIDR block for the VPC"
  value       = aws_vpc.this.cidr_block
}

output "id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.public_subnet.*.id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.private_subnet.*.id
}