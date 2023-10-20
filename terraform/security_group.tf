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