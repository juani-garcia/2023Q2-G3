output "endpoint_url" {
  value = "${aws_api_gateway_stage.this.invoke_url}/${var.endpoint_path}?name=Juan"
}