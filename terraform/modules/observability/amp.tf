resource "aws_prometheus_workspace" "this" {
  alias = "${var.project_name}-${var.environment}-amp"
}
