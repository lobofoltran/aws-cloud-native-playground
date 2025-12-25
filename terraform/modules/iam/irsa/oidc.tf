data "aws_iam_openid_connect_provider" "eks" {
  url = var.eks_oidc_url
}
