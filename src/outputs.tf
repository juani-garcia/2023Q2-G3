output "lambda_url" {
  description = "URL for Lambda function."
  value       = module.apigw["HelloWorld"].endpoint_url
}