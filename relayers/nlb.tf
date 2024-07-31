resource "aws_lb" "main" {
  count = var.relayers
  name                             = "${var.project_name}-${count.index}-lb-${var.app_tag}"
  internal                         = var.is_lb_internal
  load_balancer_type               = "network"
  subnets                          = data.aws_subnets.ec2_public_subnets.ids
  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = var.lb_delete_protection
}

resource "aws_lb_target_group" "http" {
  count = var.relayers
  depends_on = [
    aws_lb.main
  ]
  name_prefix = var.app_tag
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
  count = var.relayers
  depends_on = [
    aws_lb.main
  ]
  name_prefix = var.app_tag
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
  count = var.relayers
  load_balancer_arn = aws_lb.main[count.index].id
  port              = 9001
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.http[count.index].id
    type             = "forward"
  }
}

resource "aws_lb_listener" "tcp" {
  count = var.relayers
  load_balancer_arn = aws_lb.main[count.index].id
  port              = var.app_container_port
  protocol          = "TCP"
  ssl_policy        = ""
  default_action {
    target_group_arn = aws_lb_target_group.tcp[count.index].id
    type             = "forward"
  }
}

resource "aws_lb_listener" "tls" {
  count = var.relayers
  load_balancer_arn = aws_lb.main[count.index].id
  port              = "443"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_acm_certificate.chainsafe_io.arn
  default_action {
    target_group_arn = aws_lb_target_group.http[count.index].id
    type             = "forward"
  }

}
