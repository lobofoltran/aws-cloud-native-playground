resource "aws_iam_role" "eks_irsa_role" {
  name = "${var.project_name}-${var.environment}-eks-irsa"

  assume_role_policy = data.aws_iam_policy_document.irsa.json
}
