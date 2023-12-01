locals {
  website_bucket_name = "dine-out-website-bucket-juan23"

  lambdas = {
    "Loader" = {
      function_name  = "AWSLambdaRestaurantLoader"
      description    = "Lambda function to create a new Restaurant"
      handler        = "table_loader.lambda_handler"
      role           = data.aws_iam_role.lab_role.arn
      runtime        = "python3.9"
      create_package = false
      filename       = "./resources/lambda-test/table_loader.zip"
      http_method    = "POST"
      endpoint_path  = "load"
      source_arn     = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}"
    }
    "Reader" = {
      function_name  = "AWSLambdaRestaurantGetter"
      description    = "Lambda function to get Restaurant list"
      handler        = "table_reader.lambda_handler"
      role           = data.aws_iam_role.lab_role.arn
      runtime        = "python3.9"
      create_package = false
      filename       = "./resources/lambda-test/table_reader.zip"
      http_method    = "GET"
      endpoint_path  = "get"
      source_arn     = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}"
    }
  }
  databases = {
    "Restaurant" = {
      read_capacity  = 30
      write_capacity = 30
      billing_mode   = "PROVISIONED"
      attributes = [{
        name = "id"
        type = "N"
        }, {
        name = "Nombre"
        type = "S"
      }]
      hash_key  = "id"
      range_key = "Nombre"
    }
  }

  htmls = {
    "index.html" = {
      content      = templatefile("./resources/html/templates/index.html", { api_gateway_url = module.apigw.endpoint_url })
      path         = "./resources/html/templates/index.html"
      content_type = "text/html"
    }
    "error.html" = {
      content      = file("./resources/html/error.html")
      path         = "./resources/html/error.html"
      content_type = "text/html"
    }
  }
}