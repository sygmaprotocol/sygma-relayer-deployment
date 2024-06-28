data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.project_name}-${lower(var.env)}-vpc"
  }
}

data "aws_subnets" "ec2_private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-private-subnet"]
  }
}

data "aws_subnets" "ec2_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-public-subnet"]
  }
}

data "aws_acm_certificate" "tangle_tools" {
  domain   = "*.tangle.tools"
  statuses = ["ISSUED"]
}
