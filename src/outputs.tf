# output "my_vpc_cidr" {
#   description = "The CIDR block of the VPC created by the module"
#   value       = module.my_vpc.vpc_cidr
# }

output "my_vpc_info" {
  description = "Information about the VPC created by the module"
  value       = module.my_vpc.vpc_info
}

output "my_igw_id" {
  description = "ID of the created Internet Gateway"
  value       = module.my_igw.internet_gateway_id
}

output "my_route_table_id" {
  description = "ID of the created Route Table"
  value       = module.my_route_table.route_table_id
}