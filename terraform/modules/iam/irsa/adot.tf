data "aws_iam_policy_document" "adot_irsa" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:observability:adot-collector"]
    }
  }
}

resource "aws_iam_role" "adot" {
  name               = "${var.project_name}-${var.environment}-adot-irsa"
  assume_role_policy = data.aws_iam_policy_document.adot_irsa.json
}

resource "aws_iam_role_policy_attachment" "adot_amp" {
  role       = aws_iam_role.adot.name
  policy_arn = aws_iam_policy.amp_remote_write.arn
}
