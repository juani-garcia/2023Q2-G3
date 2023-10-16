# output "my_vpc_cidr" {
#   description = "The CIDR block of the VPC created by the module"
#   value       = module.my_vpc.vpc_cidr
# }

output "my_vpc_info" {
  description = "Information about the VPC created by the module"
  value       = module.my_vpc.vpc_info
}