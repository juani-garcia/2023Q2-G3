output "lambda_url" {

  description = "URL for Lambda function."
  value       = module.apigw
}

output "dynamodb_name" {
  description = "Name of the DynamoDB table."
  value       = module.dynamo
}