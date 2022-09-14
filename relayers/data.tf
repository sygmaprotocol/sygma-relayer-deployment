data "aws_vpc" "vpc" {
  tags = {
    Env = var.env
  }
}

data "aws_subnets" "ec2_private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["chainbridge-private-subnet"]
  }
}

data "aws_subnets" "ec2_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["chainbridge-public-subnet"]
  }
}

data "aws_acm_certificate" "chainsafe_io" {
  domain   = "*.chainsafe.io"
  statuses = ["ISSUED"]
}
