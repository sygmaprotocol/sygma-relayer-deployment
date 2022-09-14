resource "aws_cloudwatch_log_group" "logs" {
  name              = "/ecs/${var.project_name}-${var.env}"
  retention_in_days = var.log_retention_days
  tags = {
    Name = "/ecs/${var.project_name}-${var.env}"
  }
}
