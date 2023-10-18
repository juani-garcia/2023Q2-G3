variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_names" {
  type        = list(string)
  description = "List of subnet names"
}

variable "private_subnet_names" {
  type        = list(string)
  description = "List of subnet names"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zone"
}

variable "newbits" {
  type        = number
  description = "Number of bits to add to the VPC CIDR"
}

# variable "subnet_cidr_blocks" {
#   type    = list(string)
#   description = "List of subnet CIDR blocks"
# }

# Puedes agregar más variables según tus necesidades
