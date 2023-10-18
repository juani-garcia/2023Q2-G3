variable "filename" {
  description = "The path to the function's deployment package within the local filesystem. If defined, The s3_* variables cannot be used."
  type        = string
}

variable "function_name" {
  description = "A unique name for your Lambda Function."
  type        = string
}

variable "role" {
  description = "The IAM role attached to the Lambda Function."
  type        = string
}

variable "handler" {
  description = "The function entrypoint in your code."
  type        = string
}

variable "runtime" {
  description = "The identifier of the function's runtime."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs associated with the Lambda function."
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of security group IDs associated with the Lambda function."
  type        = list(string)
}
