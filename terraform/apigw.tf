module "apigw" {
  source = "./modules/apigw"
  # for_each = local.lambdas

  depends_on = [module.lambda]

  api_name     = "api-dineout"
  lambdas_info = local.lambdas
  lambdas      = module.lambda
  # lambda_function_name = each.value.function_name
  # lambda_invoke_arn    = module.lambda[each.key].invoke_arn
  # lambda_http_method   = each.value.http_method
  # lambda_source_arn    = module.lambda[each.key].arn
  # role_arn             = each.value.role
  # endpoint_path        = each.value.endpoint_path
  region     = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id

}