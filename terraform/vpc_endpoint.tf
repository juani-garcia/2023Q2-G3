module "vpc_endpoint" {
  source      = "./modules/vpc_endpoint"
  route_table = module.route_table.route_table_id
  vpc_id      = module.vpc.id
}