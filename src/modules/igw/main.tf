resource "aws_internet_gateway" "my_igw" {
  vpc_id = var.vpc_id
}

# You can add more configurations, routes, etc., as needed.
