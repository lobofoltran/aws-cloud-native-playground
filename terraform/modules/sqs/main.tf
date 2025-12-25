# =========================
# Dead Letter Queue (DLQ)
# =========================

resource "aws_sqs_queue" "dlq" {
  name = "${var.project_name}-${var.environment}-${var.queue_name}-dlq"

  message_retention_seconds = 1209600 # 14 days

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Type        = "dlq"
  }
}

# =========================
# Main Queue
# =========================

resource "aws_sqs_queue" "main" {
  name = "${var.project_name}-${var.environment}-${var.queue_name}"

  visibility_timeout_seconds = var.visibility_timeout_seconds

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = var.max_receive_count
  })

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Type        = "main"
  }
}
