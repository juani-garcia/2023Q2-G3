output "endpoint_url" {
  description = "URL for API Gateway endpoint."
  value = "${aws_api_gateway_stage.this.invoke_url}/${var.endpoint_path}?name=Juan"
}

output "domain_name" {
  description = "Domain name for API Gateway endpoint."
  value = aws_api_gateway_domain_name.this.domain_name
}

output "id" {
  description = "API Gateway ID."
  value = aws_api_gateway_rest_api.this.id
}