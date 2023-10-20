variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "egress_description" {
  description = "Description of the egress rule"
  type        = string
  default     = ""
}

variable "egress_from_port" {
  description = "From port of the egress rule"
  type        = number
  default     = 0
}

variable "egress_to_port" {
  description = "To port of the egress rule"
  type        = number
  default     = 0
}

variable "egress_protocol" {
  description = "Protocol of the egress rule"
  type        = string
  default     = "-1"
}

variable "egress_cidr_blocks" {
  description = "CIDR blocks of the egress rule"
  type        = list(string)
  default     = []
}

variable "ingress_description" {
  description = "Description of the ingress rule"
  type        = string
  default     = ""
}

variable "ingress_from_port" {
  description = "From port of the ingress rule"
  type        = number
  default     = 0
}

variable "ingress_to_port" {
  description = "To port of the ingress rule"
  type        = number
  default     = 0
}

variable "ingress_protocol" {
  description = "Protocol of the ingress rule"
  type        = string
  default     = "-1"
}

variable "ingress_cidr_blocks" {
  description = "CIDR blocks of the ingress rule"
  type        = list(string)
  default     = []
}