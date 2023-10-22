variable "vpc_id" {
  description = "ID of the VPC where the Internet Gateway will be attached"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "public" {
  description = "Whether the route table is public or not"
  type        = bool
}

variable "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  type        = string
}