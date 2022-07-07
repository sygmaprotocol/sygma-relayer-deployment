resource "aws_lb" "main" {
  name                             = "${var.project_name}-lb-${var.env}"
  internal                         = var.is_lb_internal
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = "true"

  enable_deletion_protection = var.lb_delete_protection

  dynamic "subnet_mapping" {
    for_each = toset(data.aws_subnets.ec2_public_subnets.ids)
    content {
      subnet_id     = subnet_mapping.value
      allocation_id = aws_eip.lb[subnet_mapping.key].allocation_id
    }
  }
}

resource "aws_eip" "lb" {
  for_each = toset(data.aws_subnets.ec2_public_subnets.ids)
  vpc      = true
  tags = {
    Name = "${var.project_name}-${var.env}"
  }
}

resource "aws_lb_target_group" "http" {
  name_prefix = var.env
  port        = 9001
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.vpc.id
  target_type = var.tg_target_type

  health_check {
    path     = "/health"
    protocol = "HTTP"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "tcp" {
  name_prefix = var.env
  port        = var.app_container_port
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.vpc.id
  target_type = var.tg_target_type

  health_check {
    path     = "/health"
    port     = 9001
    protocol = "HTTP"
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.id
  port              = 9001
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.http.id
    type             = "forward"
  }
}

resource "aws_lb_listener" "tcp" {
  load_balancer_arn = aws_lb.main.id
  port              = var.app_container_port
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.tcp.id
    type             = "forward"
  }
}
