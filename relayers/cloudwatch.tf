resource "aws_cloudwatch_log_group" "logs" {
  count = var.relayers
  name              = "/ecs/${var.project_name}-${count.index}-${var.app_tag}"
  retention_in_days = var.log_retention_days
  tags = {
    Name = "/ecs/${var.project_name}-${count.index}-${var.app_tag}"
  }
}
