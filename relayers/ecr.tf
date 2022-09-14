resource "aws_ecr_repository" "main" {
  count = var.enable_ecr ? 1 : 0
  name                 = lower("${var.project_name}-${var.env}")
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = var.ecr_scan_on_push
  }

  tags = {
    Name = var.project_name
  }
}

resource "aws_ecr_lifecycle_policy" "main" {
  count = var.enable_ecr ? 1 : 0
  repository = aws_ecr_repository.main[count.index].name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 20 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 20
      }
    }]
  })
}
