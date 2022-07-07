resource "aws_efs_file_system" "efs" {
  tags = {
    Name = "${var.project_name}-efs-${var.env}"
  }
}

resource "aws_efs_mount_target" "main" {
  count = length(data.aws_subnets.ec2_private_subnets.ids)

  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = element(data.aws_subnets.ec2_private_subnets.ids, count.index)

  security_groups = [
    aws_security_group.efs.id,
  ]

}

resource "aws_security_group" "efs" {
  name        = "${var.project_name}-efs-${var.env}"
  description = "Allows NFS traffic from instances within the VPC."
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    cidr_blocks = [
      data.aws_vpc.vpc.cidr_block,
    ]
  }

  egress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    cidr_blocks = [
      data.aws_vpc.vpc.cidr_block,
    ]
  }

  tags = {
    Name = "${var.project_name}-efs-${var.env}"
  }
}