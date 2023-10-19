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

#   api_name             = "api-test"
#   lambda_function_name = module.lambda[each.key].function_name
#   lambda_invoke_arn    = module.lambda[each.key].invoke_arn

#   depends_on = [module.lambda]
# }

module "s3" {
  source      = "./modules/s3"
  bucket_name = "bucket-test"
  acl         = "public-read"
}