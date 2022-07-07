resource "aws_cloudwatch_log_group" "logs" {
  count             = var.number_of_relayers
  name              = "/ecs/${var.project_name}-${var.env}-${count.index}"
  retention_in_days = var.log_retention_days
  tags = {
    Name = "/ecs/${var.project_name}-${var.env}"
  }
}
