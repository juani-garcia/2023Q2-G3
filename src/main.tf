module "vpc" {
  source               = "./modules/vpc"
  vpc_name             = "vpc-test"
  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnet_names  = ["Public Subnet 1", "Public Subnet 2"]
  private_subnet_names = ["Private Subnet 1", "Private Subnet 2"]
  newbits              = 8
}

module "igw" {
  source = "./modules/igw"
  vpc_id = module.vpc.id
}

module "route_table" {
  source         = "./modules/route_table"
  vpc_id         = module.vpc.id
  subnet_ids     = module.vpc.public_subnets
  public         = true
  gateway_id     = module.igw.id
  nat_gateway_id = null # TODO: Add nat gateway module to be used for private subnets
}

module "sg" {
  source = "./modules/security_group"

  vpc_id = module.vpc.id
  name   = "sg"

  egress_description = "Test"
  egress_from_port   = 443
  egress_to_port     = 443
  egress_protocol    = "tcp"
  egress_cidr_blocks = [module.vpc.cidr]

}

module "lambda" {
  source   = "./modules/lambda"
  for_each = local.lambdas

  depends_on = [module.vpc]

  filename      = each.value.filename
  function_name = each.value.function_name
  role          = each.value.role
  handler       = each.value.handler
  runtime       = each.value.runtime

  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [module.sg.id]

}

module "apigw" {
  source   = "./modules/apigw"
  for_each = local.lambdas

  api_name             = "api-test"
  lambda_function_name = each.value.function_name
  lambda_invoke_arn    = module.lambda[each.key].invoke_arn
  lambda_http_method   = each.value.http_method
  lambda_source_arn    = module.lambda[each.key].arn
  role_arn             = each.value.role
  endpoint_path        = each.value.endpoint_path
  region               = data.aws_region.current.name
  account_id           = data.aws_caller_identity.current.account_id

  depends_on = [module.lambda]
}

# module "apigw" {
#   source = "terraform-aws-modules/apigateway-v2/aws"
#   for_each = local.lambdas

#   name          = "http-apigateway"
#   protocol_type = "HTTP"

#   cors_configuration = {
#     allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
#     allow_methods = ["*"]
#     allow_origins = ["*"]
#   }

#   # Custom domain
#   domain_name                 = "terraform-aws-modules.modules.tf"
#   domain_name_certificate_arn = ""

#   # # Access logs
#   # default_stage_access_log_destination_arn = "arn:aws:logs:eu-west-1:835367859851:log-group:debug-apigateway"
#   # default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

#   # Routes and integrations
#   integrations = {
#     "POST /" = {
#       lambda_arn             = module.lambda[each.key].arn
#       payload_format_version = "2.0"
#       timeout_milliseconds   = 12000
#     }

#     # "GET /some-route-with-authorizer" = {
#     #   integration_type = "HTTP_PROXY"
#     #   integration_uri  = module.lambda[each.key].invoke_arn
#     #   authorizer_key   = "aws"
#     # }

#     "$default" = {
#       lambda_arn = module.lambda[each.key].arn
#     }
#   }

#   authorizers = {
#     # "azure" = {
#     #   authorizer_type  = "JWT"
#     #   identity_sources = "$request.header.Authorization"
#     #   name             = "azure-auth"
#     #   audience         = ["d6a38afd-45d6-4874-d1aa-3c5c558aqcc2"]
#     #   issuer           = "https://sts.windows.net/aaee026e-8f37-410e-8869-72d9154873e4/"
#     # }
#   }

#   tags = {
#     Name = "http-apigateway"
#   }

# }