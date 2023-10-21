module "vpc" {
  source               = "./modules/vpc"
  vpc_name             = "vpc-test"
  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnet_names  = ["Public Subnet 1", "Public Subnet 2"]
  private_subnet_names = ["Private Subnet 1", "Private Subnet 2"]
  newbits              = 8
}