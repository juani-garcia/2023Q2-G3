variable "api_name" {
  description = "The name of the API."
  type        = string
}

# variable "lambda_function_name" {
#   description = "The name of the Lambda function."
#   type        = string
# }

# variable "lambda_invoke_arn" {
#   description = "The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_lambda_permission's source_arn attribute."
#   type        = string
# }

# variable "lambda_http_method" {
#   description = "The HTTP method to be used for invoking Lambda Function from API Gateway."
#   type        = string
# }

# variable "lambda_source_arn" {
#   description = "The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_lambda_permission's source_arn attribute."
#   type        = string
# }

# variable "role_arn" {
#   description = "The ARN of the IAM role that API Gateway assumes when calling the Lambda function."
#   type        = string
# }

# variable "endpoint_path" {
#   description = "The path under which the API Gateway Lambda function invoker is registered. Default is /{lambda_function_name}."
#   type        = string
# }

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