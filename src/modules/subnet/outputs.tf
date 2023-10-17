output "subnet_info" {
  description = "Information about the created subnets"
  value = {
    ids                      = aws_subnet.subnet.*.id
    subnet_cidr_blocks       = aws_subnet.subnet.*.cidr_block
    map_public_ips_on_launch = aws_subnet.subnet.*.map_public_ip_on_launch
  }
}