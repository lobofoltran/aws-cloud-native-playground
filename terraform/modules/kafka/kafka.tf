resource "aws_msk_cluster" "this" {
  cluster_name           = "${var.project_name}-${var.environment}-kafka"
  kafka_version          = var.kafka_version
  number_of_broker_nodes = length(var.private_subnets)

  broker_node_group_info {
    instance_type   = var.broker_instance_type
    client_subnets  = var.private_subnets
    security_groups = [aws_security_group.kafka.id]
  }
}
