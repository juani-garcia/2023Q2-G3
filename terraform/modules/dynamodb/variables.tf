variable "name" {
  description = "The name of the DynamoDB table"
  type        = string
}

variable "write_capacity" {
  description = "The number of write units for this table"
  type        = number
}

variable "read_capacity" {
  description = "The number of read units for this table"
  type        = number
}

variable "billing_mode" {
  description = "The billing mode for this table"
  type        = string
}

variable "attributes" {
  description = "The attributes for this table"
  type = list(object({
    name = string
    type = string
  }))
}

variable "hash_key" {
  description = "The hash key for this table"
  type        = string
}

variable "range_key" {
  description = "The range key for this table"
  type        = string
}

variable "tags" {
  description = "The tags for this table"
  type        = map(string)
}

