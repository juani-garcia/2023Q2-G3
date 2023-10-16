output "lambda_functions_arns" {
  value = aws_lambda_function.lambda_function.*.arn
}
