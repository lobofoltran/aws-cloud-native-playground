resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment}-db-subnets"
  subnet_ids = var.private_subnets

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
