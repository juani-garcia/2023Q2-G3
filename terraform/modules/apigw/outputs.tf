output "id" {
  description = "API Gateway ID."
  value       = aws_api_gateway_rest_api.this.id
}

output "endpoint_url" {
  description = "API Gateway endpoint."
  value       = "${aws_api_gateway_stage.this.invoke_url}/hello"
}

output "api_endpoint" {
  description = "API Gateway endpoint."
  value       = aws_api_gateway_stage.this.invoke_url
}