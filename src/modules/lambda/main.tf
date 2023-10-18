resource "aws_lambda_function" "this" {
  filename      = var.filename
  function_name = var.function_name
  role          = var.role
  handler       = var.handler
  runtime       = var.runtime
  tags = {
    Name = var.function_name
  }

  dynamic "vpc_config" {
    for_each = var.subnet_ids != null && var.security_group_ids != null ? [true] : []
    content {
      security_group_ids = var.security_group_ids
      subnet_ids         = var.subnet_ids
    }
  }

  # vpc_config {
  #   subnet_ids         = var.subnet_ids
  #   security_group_ids = var.security_group_ids
  # }

  timeouts {
    create = "30m"
  }

}
