resource "aws_api_gateway_rest_api" "this" {
  name = var.api_name
}

resource "aws_api_gateway_resource" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = var.endpoint_path
}

resource "aws_api_gateway_method" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.this.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.this.id
  http_method             = aws_api_gateway_method.this.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.this.id}/*/${aws_api_gateway_method.this.http_method}${aws_api_gateway_resource.this.path}"
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_api_gateway_method.this, aws_api_gateway_integration.integration]

}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "dev"
}

## Third try:

# resource "aws_api_gateway_rest_api" "this" {
#   name = var.api_name
# }

# resource "aws_api_gateway_resource" "this" {
#   path_part   = "hello"
#   parent_id   = aws_api_gateway_rest_api.this.root_resource_id
#   rest_api_id = aws_api_gateway_rest_api.this.id
# }

# resource "aws_api_gateway_method" "hello_get" {
#   rest_api_id   = aws_api_gateway_rest_api.this.id
#   resource_id   = aws_api_gateway_resource.this.id
#   http_method   = var.lambda_http_method
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "this" {
#   rest_api_id   = aws_api_gateway_rest_api.this.id
#   resource_id   = aws_api_gateway_resource.this.id
#   http_method   = "POST"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "options" {
#   rest_api_id   = aws_api_gateway_rest_api.this.id
#   resource_id   = aws_api_gateway_resource.this.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "hello_get" {
#   rest_api_id             = aws_api_gateway_rest_api.this.id
#   resource_id             = aws_api_gateway_resource.this.id
#   http_method             = aws_api_gateway_method.hello_get.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = var.lambda_invoke_arn
# }

# resource "aws_api_gateway_integration" "this" {
#   rest_api_id             = aws_api_gateway_rest_api.this.id
#   resource_id             = aws_api_gateway_resource.this.id
#   http_method             = aws_api_gateway_method.this.http_method
#   integration_http_method = "POST"
#   type                    = "AWS"
#   credentials             = var.role_arn
#   uri                     = var.lambda_invoke_arn

#   request_parameters = {
#     "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
#   }

#   request_templates = {
#     "application/json" = <<EOF
# Action=SendMessage&MessageBody={
#   "method": "$context.httpMethod",
#   "body-json" : $input.json('$'),
#   "queryParams": {
#     #foreach($param in $input.params().querystring.keySet())
#     "$param": "$util.escapeJavaScript($input.params().querystring.get($param))" #if($foreach.hasNext),#end
#   #end
#   },
#   "pathParams": {
#     #foreach($param in $input.params().path.keySet())
#     "$param": "$util.escapeJavaScript($input.params().path.get($param))" #if($foreach.hasNext),#end
#     #end
#   }
# }
# EOF
#   }

#   depends_on = [aws_api_gateway_method.options]
# }

# resource "aws_api_gateway_integration" "options" {
#   rest_api_id = aws_api_gateway_rest_api.this.id
#   resource_id = aws_api_gateway_resource.this.id
#   http_method = aws_api_gateway_method.options.http_method
#   type        = "MOCK"

#   request_parameters = {}
#   request_templates = {
#     "application/json" = jsonencode(
#       {
#         statusCode = 200
#       }
#     )
#   }

#   depends_on = [aws_api_gateway_method.options]
# }

# resource "aws_api_gateway_stage" "this" {
#   deployment_id = aws_api_gateway_deployment.this.id
#   rest_api_id   = aws_api_gateway_rest_api.this.id
#   stage_name    = "production"
# }

# resource "aws_api_gateway_method_response" "http200" {
#   rest_api_id = aws_api_gateway_rest_api.this.id
#   resource_id = aws_api_gateway_resource.this.id
#   http_method = aws_api_gateway_method.this.http_method
#   status_code = 200

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin" = "true"
#   }

#   depends_on = [aws_api_gateway_method.this]
# }

# resource "aws_api_gateway_method_response" "hello200" {
#   rest_api_id = aws_api_gateway_rest_api.this.id
#   resource_id = aws_api_gateway_resource.this.id
#   http_method = aws_api_gateway_method.hello_get.http_method
#   status_code = 200

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin" = "true"
#   }

#   depends_on = [aws_api_gateway_method.hello_get]
# }

# resource "aws_api_gateway_method_response" "options200" {
#   rest_api_id = aws_api_gateway_rest_api.this.id
#   resource_id = aws_api_gateway_resource.this.id
#   http_method = aws_api_gateway_method.options.http_method
#   status_code = 200
#   response_models = {
#     "application/json" = "Empty"
#   }

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true,
#     "method.response.header.Access-Control-Allow-Methods" = true,
#     "method.response.header.Access-Control-Allow-Origin"  = true
#   }

#   depends_on = [aws_api_gateway_method.options]
# }

# resource "aws_api_gateway_integration_response" "http200" {
#   rest_api_id       = aws_api_gateway_rest_api.this.id
#   resource_id       = aws_api_gateway_resource.this.id
#   http_method       = aws_api_gateway_method.this.http_method
#   status_code       = aws_api_gateway_method_response.http200.status_code
#   selection_pattern = "^2[0-9][0-9]"
#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin" = "'*'"
#   }

#   depends_on = [aws_api_gateway_method_response.http200]
# }

# resource "aws_api_gateway_integration_response" "hello200" {
#   rest_api_id       = aws_api_gateway_rest_api.this.id
#   resource_id       = aws_api_gateway_resource.this.id
#   http_method       = aws_api_gateway_method.hello_get.http_method
#   status_code       = aws_api_gateway_method_response.hello200.status_code
#   selection_pattern = "^2[0-9][0-9]"
#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin" = "'*'"
#   }

#   depends_on = [aws_api_gateway_method_response.hello200]
# }

# resource "aws_api_gateway_integration_response" "options200" {
#   rest_api_id = aws_api_gateway_rest_api.this.id
#   resource_id = aws_api_gateway_resource.this.id
#   http_method = aws_api_gateway_method.options.http_method
#   status_code = aws_api_gateway_method_response.http200.status_code
#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
#     "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST'",
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#   }

#   depends_on = [aws_api_gateway_method_response.options200]
# }

# resource "aws_api_gateway_deployment" "this" {
#   rest_api_id = aws_api_gateway_rest_api.this.id

#   triggers = {
#     redeployment = sha1(jsonencode([
#       aws_api_gateway_resource.this.id,
#       aws_api_gateway_method.this.id,
#       aws_api_gateway_method.options.id,
#       aws_api_gateway_method.hello_get.id,
#       aws_api_gateway_integration.this.id,
#       aws_api_gateway_integration.options.id,
#       aws_api_gateway_integration.hello_get.id,
#     ]))
#   }

#   lifecycle {
#     create_before_destroy = true
#   }

#   depends_on = [
#     aws_api_gateway_integration.options,
#     aws_api_gateway_integration.this,
#     aws_api_gateway_integration.hello_get,
#     aws_api_gateway_method.options,
#     aws_api_gateway_method.this,
#     aws_api_gateway_method.hello_get,
#     aws_api_gateway_method_response.options200,
#     aws_api_gateway_method_response.http200,
#     aws_api_gateway_method_response.hello200,
#     aws_api_gateway_integration_response.options200,
#     aws_api_gateway_integration_response.hello200,
#     aws_api_gateway_integration_response.hello200,
#   ]
# }

# resource "aws_lambda_permission" "this" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = var.lambda_function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = var.lambda_source_arn
# }

# 2nd try:

# resource "aws_api_gateway_rest_api" "this" {
#   name = var.api_name
# }

# resource "aws_api_gateway_method" "root" {
#   rest_api_id = aws_api_gateway_rest_api.this.id
#   resource_id = aws_api_gateway_rest_api.this.root_resource_id
#   http_method = "POST"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "root" {
#   rest_api_id = aws_api_gateway_rest_api.this.id
#   resource_id = aws_api_gateway_method.root.resource_id
#   http_method = aws_api_gateway_method.root.http_method

#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                    = var.lambda_invoke_arn
# }

# resource "aws_api_gateway_method" "options" {
#   rest_api_id = aws_api_gateway_rest_api.this.id
#   resource_id = aws_api_gateway_rest_api.this.root_resource_id
#   http_method = "OPTIONS"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "this" {
#   rest_api_id = aws_api_gateway_rest_api.this.id
#   resource_id = aws_api_gateway_method.options.resource_id
#   http_method = aws_api_gateway_method.options.http_method

#   integration_http_method = "OPTIONS"
#   type                    = "AWS_PROXY"
#   uri                    = var.lambda_invoke_arn
# }

# resource "aws_api_gateway_deployment" "this" {
#   depends_on = [
#     aws_api_gateway_integration.root
#   ]

#   rest_api_id = aws_api_gateway_rest_api.this.id
#   stage_name  = "test_stage"
# }

## 1st try:

# resource "aws_api_gateway_rest_api" "this" {
#   name = var.api_name
# }

# resource "aws_api_gateway_resource" "proxy" {
#   rest_api_id = aws_api_gateway_rest_api.this.id
#   parent_id   = aws_api_gateway_rest_api.this.root_resource_id
#   path_part   = "{proxy+}"
# }

# resource "aws_api_gateway_method" "proxy" {
#   rest_api_id   = aws_api_gateway_rest_api.this.id
#   resource_id   = aws_api_gateway_resource.proxy.id
#   http_method   = "GET"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "lambda" {
#   rest_api_id = aws_api_gateway_rest_api.this.id
#   resource_id = aws_api_gateway_method.proxy.resource_id
#   http_method = aws_api_gateway_method.proxy.http_method

#   integration_http_method = "GET"
#   type                    = "AWS_PROXY"
#   uri                     = var.lambda_invoke_arn
# }

# # resource "aws_api_gateway_method" "proxy_root" {
# #   rest_api_id   = "${aws_api_gateway_rest_api.example.id}"
# #   resource_id   = "${aws_api_gateway_rest_api.example.root_resource_id}"
# #   http_method   = "ANY"
# #   authorization = "NONE"
# # }

# # resource "aws_api_gateway_integration" "lambda_root" {
# #   rest_api_id = "${aws_api_gateway_rest_api.example.id}"
# #   resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
# #   http_method = "${aws_api_gateway_method.proxy_root.http_method}"

# #   integration_http_method = "POST"
# #   type                    = "AWS_PROXY"
# #   uri                     = "${aws_lambda_function.example.invoke_arn}"
# # }

# resource "aws_api_gateway_deployment" "this" {
#   depends_on = [
#     aws_api_gateway_integration.lambda
#   ]

#   rest_api_id = aws_api_gateway_rest_api.this.id
#   stage_name  = "test"
# }

# resource "aws_lambda_permission" "apigw" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = var.lambda_function_name
#   principal     = "apigateway.amazonaws.com"

#   # The /*/* portion grants access from any method on any resource
#   # within the API Gateway "REST API".
#   source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
# }