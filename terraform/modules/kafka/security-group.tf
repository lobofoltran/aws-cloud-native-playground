resource "aws_security_group" "kafka" {
  name   = "${var.project_name}-${var.environment}-kafka-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 9092
    to_port         = 9092
    protocol        = "tcp"
    security_groups = []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
