module "igw" {
  source = "./modules/igw"
  vpc_id = module.vpc.id
}