module "my_vpc" {
  source       = "./modules/vpc"
  vpc_name     = "vpc-test"
  vpc_cidr     = "10.0.0.0/16"
  az           = "us-east-1a"
  subnet_names = ["Public Subnet 1", "Public Subnet 2"]
  newbits      = 8
}