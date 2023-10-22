variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "starting_cidr" {
  description = "Offset for starting subnet cidr block"
  type        = number
}

variable "map_public_ip_on_launch" {
  description = "Map public IP on launch"
  type        = bool
  default     = false
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet"
}

variable "az" {
  type        = string
  description = "Availability Zone"
}

variable "newbits" {
  type        = number
  description = "Number of bits to add to the VPC CIDR"
}
