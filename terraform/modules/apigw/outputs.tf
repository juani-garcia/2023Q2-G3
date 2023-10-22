output "id" {
  description = "API Gateway ID."
  value       = aws_api_gateway_rest_api.this.id
}

output "endpoint_urls" {

  description = "API Gateway endpoint."
  value = {
    for key, value in var.lambdas_info : "${aws_api_gateway_stage.this.invoke_url}/${value.endpoint_path}" => key
  }
}

output "endpoint_url" {
  description = "API Gateway endpoint."
  value       = aws_api_gateway_stage.this.invoke_url
}