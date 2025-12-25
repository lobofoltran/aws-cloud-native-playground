output "bootstrap_brokers" {
  value = aws_msk_cluster.this.bootstrap_brokers
}

output "security_group_id" {
  value = aws_security_group.kafka.id
}
