output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "eks_irsa_role_arn" {
  value = aws_iam_role.eks_irsa_role.arn
}
