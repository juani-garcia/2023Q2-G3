variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "cidr_blocks" {
  description = "List of CIDR blocks"
  type        = list(string)
}