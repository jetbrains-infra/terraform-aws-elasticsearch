resource "aws_security_group" "elasticsearch" {
  name   = "ES-${local.domain_name}"
  vpc_id = local.vpc_id

  ingress {
    protocol    = "TCP"
    from_port   = 0
    to_port     = 65535
    cidr_blocks = local.trusted_cidr_blocks
  }

  tags = {
    Project = local.project
  }
}

