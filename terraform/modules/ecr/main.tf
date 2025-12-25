resource "aws_ecr_repository" "this" {
  name                 = "${var.project_name}-${var.environment}-${var.repository_name}"
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Service     = var.repository_name
  }
}
