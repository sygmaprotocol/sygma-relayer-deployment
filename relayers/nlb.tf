resource "aws_lb" "main" {
  name                             = "${var.project_name}-lb-${var.env}"
  internal                         = var.is_lb_internal
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = "true"

  enable_deletion_protection = var.lb_delete_protection

  subnets  = data.aws_subnets.ec2_public_subnets.ids
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
