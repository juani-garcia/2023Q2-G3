# module "vpc" {
#   source               = "./modules/vpc"
#   vpc_name             = "vpc-test"
#   vpc_cidr             = "10.0.0.0/16"
#   azs                  = ["us-east-1a", "us-east-1b"]
#   public_subnet_names  = ["Public Subnet 1", "Public Subnet 2"]
#   private_subnet_names = ["Private Subnet 1", "Private Subnet 2"]
#   newbits              = 8
# }

# module "igw" {
#   source = "./modules/igw"
#   vpc_id = module.vpc.id
# }

# module "route_table" {
#   source         = "./modules/route_table"
#   vpc_id         = module.vpc.id
#   subnet_ids     = module.vpc.public_subnets
#   public         = true
#   gateway_id     = module.igw.id
#   nat_gateway_id = null # TODO: Add nat gateway module to be used for private subnets
# }

# module "sg" {
#   source = "./modules/security_group"

#   vpc_id = module.vpc.id
#   name   = "sg"

#   egress_description = "Test"
#   egress_from_port   = 443
#   egress_to_port     = 443
#   egress_protocol    = "tcp"
#   egress_cidr_blocks = [module.vpc.cidr]

# }

# module "lambda" {
#   source   = "./modules/lambda"
#   for_each = local.lambdas

#   depends_on = [module.vpc]

#   filename      = each.value.filename
#   function_name = each.value.function_name
#   role          = each.value.role
#   handler       = each.value.handler
#   runtime       = each.value.runtime

#   subnet_ids         = module.vpc.private_subnets
#   security_group_ids = [module.sg.id]

# }

# module "apigw" {
#   source   = "./modules/apigw"
#   for_each = local.lambdas

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

module "dynamo" {
  source   = "./modules/dynamodb"
  for_each = local.databases

  name           = each.key
  read_capacity  = each.value.read_capacity
  write_capacity = each.value.write_capacity
  billing_mode   = each.value.billing_mode
  attributes     = each.value.attributes
  hash_key       = each.value.hash_key
  range_key      = each.value.range_key
  tags           = { name = each.key }

}

module "cloudfront" {
  source = "./modules/cloudfront"

  depends_on = [ module.apigw ]

  origins = {
    api_gw = {
      domain_name              = module.apigw.domain_name
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  default_cache_behaviors = {
    default = {
      allowed_methods        = ["GET", "HEAD", "OPTIONS"]
      cached_methods         = ["GET", "HEAD", "OPTIONS"]
      target_origin_id       = module.apigw.id
      viewer_protocol_policy = "allow-all"
      query_string           = false
      cookies_forward        = "none"
    }
  }
}
