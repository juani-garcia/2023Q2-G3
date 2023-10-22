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

  # TODO: The following is not allowed. Throwing a runtime error using locals is suggested instead. Verify that's appropriate.

  # validation {
  #   condition     = (var.public == true && var.nat_gateway_id == null) || (var.public == false && var.nat_gateway_id != null)
  #   error_message = "NAT Gateway ID is required when the route table is private"
  # }
}