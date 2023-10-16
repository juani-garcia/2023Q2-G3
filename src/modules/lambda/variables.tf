# variable "lambda_function_name" {
#   description = "The name of the Lambda function"
#   type        = string
#   default     = "lambda-function"
# }

# variable "lambda_handler" {
#   description = "The name of the Lambda handler"
#   type        = string
#   default     = "lambda_handler"
# }

variable "sources" {
  description = "The source code for the Lambda function"
  type        = list(string)
  default     = ["src/resources"]
}

variable "lambda_names" {
  description = "The name of the Lambda function"
  type        = list(string)
  default     = ["lambda-function"]
}

