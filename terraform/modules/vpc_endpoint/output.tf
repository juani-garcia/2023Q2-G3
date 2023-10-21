output "vpc_endpoint" {
  description = "VPC endpoint for Dynamo"
  value       = aws_vpc_endpoint.dynamo_vpc_endpoint.id
}