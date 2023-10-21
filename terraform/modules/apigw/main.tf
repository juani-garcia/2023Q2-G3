resource "aws_api_gateway_rest_api" "this" {
  name = var.api_name
}

resource "aws_api_gateway_resource" "this" {
  for_each = var.lambdas_info

  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = each.value.endpoint_path
}

resource "aws_api_gateway_method" "this" {
  for_each = var.lambdas_info

  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.this[each.key].id
  http_method   = each.value.http_method
  authorization = "NONE"
}

resource "aws_api_gateway_method" "options" {
  for_each = var.lambdas_info

  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.this[each.key].id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  for_each = var.lambdas_info

  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.this[each.key].id
  http_method             = aws_api_gateway_method.this[each.key].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambdas[each.key].invoke_arn
  
}

resource "aws_api_gateway_integration" "options" {
  for_each = var.lambdas_info

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.this[each.key].id
  http_method = aws_api_gateway_method.options[each.key].http_method
  type        = "MOCK"

  request_parameters = {}
  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }

  # depends_on = [aws_api_gateway_method.options[each.key]]
}

resource "aws_lambda_permission" "this" {
  for_each = var.lambdas_info

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.this.id}/*/${aws_api_gateway_method.this[each.key].http_method}${aws_api_gateway_resource.this[each.key].path}"
}

resource "aws_api_gateway_method_response" "this" {
  for_each = var.lambdas_info

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.this[each.key].id
  http_method = aws_api_gateway_method.this[each.key].http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "true"
  }

  depends_on = [aws_api_gateway_method.this]
}

resource "aws_api_gateway_method_response" "options" {
  for_each = var.lambdas_info

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.this[each.key].id
  http_method = aws_api_gateway_method.options[each.key].http_method
  status_code = 200
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = [aws_api_gateway_method.options]
}

resource "aws_api_gateway_integration_response" "this" {
  for_each = var.lambdas_info

  rest_api_id       = aws_api_gateway_rest_api.this.id
  resource_id       = aws_api_gateway_resource.this[each.key].id
  http_method       = aws_api_gateway_method.this[each.key].http_method
  status_code       = aws_api_gateway_method_response.this[each.key].status_code
  selection_pattern = "^2[0-9][0-9]"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [aws_api_gateway_method_response.this]
}

resource "aws_api_gateway_integration_response" "options" {
  for_each = var.lambdas_info

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.this[each.key].id
  http_method = aws_api_gateway_method.options[each.key].http_method
  status_code = aws_api_gateway_method_response.this[each.key].status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [aws_api_gateway_method_response.options]
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }

  # triggers = {
  #   redeployment = sha1(jsonencode([
  #     aws_api_gateway_resource.this[*],#.id,
  #     aws_api_gateway_method.this[*],#.id,
  #     aws_api_gateway_method.options[*],#.id,
  #     aws_api_gateway_integration.integration[*],#.id,
  #     aws_api_gateway_integration.options[*],#.id,
  #   ]))
  # }

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_api_gateway_method.this, aws_api_gateway_integration.integration] #, aws_api_gateway_method.options, aws_api_gateway_integration.options]

}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "prod"
}