## ALB Security Group
resource "aws_security_group" "lb" {
  name   = "${var.project_name}-sg-alb-${var.app_tag}"
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = var.app_container_port
    to_port          = var.app_container_port
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 9001
    to_port     = 9001
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

## ECS Task Security Group
resource "aws_security_group" "ecs_tasks" {
  name   = "${var.project_name}-sg-task-${var.app_tag}"
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 9000
    to_port     = 9000
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 9001
    to_port     = 9001
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
