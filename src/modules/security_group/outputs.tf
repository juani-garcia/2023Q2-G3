output "sg_info" {
  description = "Information about the created security group"
  value = {
    sg_id       = aws_security_group.sg.id
    name        = aws_security_group.sg.name
    description = aws_security_group.sg.description
    vpc_id      = aws_security_group.sg.vpc_id
    ingress     = aws_security_group.sg.ingress
    egress      = aws_security_group.sg.egress
    tags        = aws_security_group.sg.tags
  }
}