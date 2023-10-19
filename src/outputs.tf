output "url" {
  description = "url of the bucket"
  value       = module.dine_out_website_bucket.s3_bucket_website_endpoint
}
    
output "lambda_url" {

  description = "URL for Lambda function."
  value       = module.apigw
}

output "dynamodb_name" {
  description = "Name of the DynamoDB table."
  value       = module.dynamo
}

output "cloudfront_access" {
  description = "Cloudfront access."
  value       = module.cloudfront
}