module "my_vpc" {
  source               = "./modules/vpc"
  vpc_name             = "vpc-test"
  vpc_cidr             = "10.0.0.0/16"
  az                   = "us-east-1a" # TODO: Add support for multiple AZs
  public_subnet_names  = ["Public Subnet 1", "Public Subnet 2"]
  private_subnet_names = ["Private Subnet 1", "Private Subnet 2"]
  newbits              = 8
}

module "my_igw" {
  source = "./modules/igw"
  vpc_id = module.my_vpc.vpc_info.vpc_id
}

module "my_route_table" {
  source         = "./modules/route_table"
  vpc_id         = module.my_vpc.vpc_info.vpc_id
  subnet_ids     = module.my_vpc.vpc_info.public_subnets
  public         = true
  gateway_id     = module.my_igw.internet_gateway_id
  nat_gateway_id = null # TODO: Add nat gateway module to be used for private subnets
}

# module "lambda_function_existing_package_local" {
#   source = "terraform-aws-modules/lambda/aws"

#   function_name = "my-lambda-existing-package-local-test"
#   description   = "Test lambda function"
#   handler       = "hello_world.lambda_handler"
#   runtime       = "python3.9"

#   create_package         = false
#   local_existing_package = "./resources/lambda-test/hello_world.zip"
# }

module "sg" {
  source      = "./modules/security_group"
  vpc_id      = module.my_vpc.vpc_info.vpc_id
  cidr_blocks = ["10.0.3.0/24"] # TODO: avoid hard-coding
}

module "lambda_function" {
  source       = "./modules/lambda"
  sources      = ["src/resources/lambda-test"]
  lambda_names = ["hello-world-test"]
  subnets      = module.my_vpc.vpc_info.private_subnets[0]
  sgs          = [module.sg.sg_id]
}