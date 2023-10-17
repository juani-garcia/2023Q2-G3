# Taken from https://terrateam.io/blog/aws-lambda-function-with-terraform
# TODO: implement this module

resource "aws_security_group" "sg" {
  name_prefix = "example-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}