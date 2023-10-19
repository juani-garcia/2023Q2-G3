output "url" {
  description = "url of the bucket"
  value       = module.website_bucket.s3_bucket_website_endpoint
}
    
output "lambda_url" {

  description = "URL for Lambda function."
  value       = module.apigw
}

output "dynamodb_name" {
  description = "Name of the DynamoDB table."
  value       = module.dynamo
}