output "amp_workspace_id" {
  value = aws_prometheus_workspace.this.id
}

output "amp_endpoint" {
  value = aws_prometheus_workspace.this.prometheus_endpoint
}

output "grafana_url" {
  value = aws_grafana_workspace.this.endpoint
}
