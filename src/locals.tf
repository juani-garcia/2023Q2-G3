locals {
  website_bucket_name = "dine-out-website-bucket"

  lambdas = {
    "HelloWorld" = {
      function_name  = "AWSLambdaHelloWorldTest"
      description    = "Test lambda function"
      handler        = "hello_world.lambda_handler"
      role           = data.aws_iam_role.lab_role.arn
      runtime        = "python3.9"
      create_package = false
      filename       = "./resources/lambda-test/hello_world.zip"
    }
  }

  htmls = {
    "index" = {
      file_name = "index.html"
      mime      = "text/html"
    }
    "error" = {
      file_name = "error.html"
      mime      = "text/html"
    }
  }
}