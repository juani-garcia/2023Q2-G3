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