variable "api_name" {
  description = "The name of the API."
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the Lambda function."
  type        = string
}

variable "lambda_invoke_arn" {
  description = "The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_lambda_permission's source_arn attribute."
  type        = string
}