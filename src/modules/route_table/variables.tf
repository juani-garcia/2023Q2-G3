variable "vpc_id" {
  description = "ID of the VPC where the Internet Gateway will be attached"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "gateway_id" {
  description = "ID of the Internet Gateway"
  type        = string
}