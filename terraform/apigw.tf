module "apigw" {
  source = "./modules/apigw"

  depends_on = [module.lambda]

  api_name     = "api-dineout"
  lambdas_info = local.lambdas
  lambdas      = module.lambda
  region       = data.aws_region.current.name
  account_id   = data.aws_caller_identity.current.account_id

}