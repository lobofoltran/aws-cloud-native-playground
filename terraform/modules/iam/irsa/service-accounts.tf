data "aws_iam_policy_document" "irsa" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.eks.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_oidc_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:go-worker"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_sqs" {
  role       = aws_iam_role.eks_irsa_role.name
  policy_arn = aws_iam_policy.sqs_access.arn
}
