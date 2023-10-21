output "apigw_info" {
  description = "URL for Lambda function."
  value       = module.apigw
}

output "dynamodb_name" {
  description = "Name of the DynamoDB table."
  value       = module.dynamo
}

output "cloudfront_domain_name" {
  description = "Cloudfront access."
  value       = module.cloudfront.domain_name
}

output "vpc_id" {
  description = "Id of the VPC"
  value       = module.vpc.id
}