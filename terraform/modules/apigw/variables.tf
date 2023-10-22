variable "api_name" {
  description = "The name of the API."
  type        = string
}

variable "region" {
  description = "The region in which the API is created."
  type        = string
}

variable "account_id" {
  description = "The ID of the AWS account where the API is created."
  type        = string
}

variable "lambdas" {
  description = "The lambdas to be used in the API Gateway."
  type        = map(any)
}

variable "lambdas_info" {
  description = "The lambdas to be used in the API Gateway."
  type        = map(any)
}