output "arn" {
  description = "value of the lambda function ARN"
  value       = aws_lambda_function.this.arn
}

output "function_name" {
  description = "value of the lambda function name"
  value       = aws_lambda_function.this.function_name
}