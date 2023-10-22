module "route_table" {
  source         = "./modules/route_table"
  vpc_id         = module.vpc.id
  subnet_ids     = module.vpc.private_subnets
  public         = true
  nat_gateway_id = null # TODO: Add nat gateway module to be used for private subnets
}