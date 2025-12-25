# ==================================
# IAM Module Entry Point
# ==================================
# This file exists to:
# - Declare shared data sources
# - Control evaluation order
# - Provide a clear module boundary
#
# Resource definitions live in:
# - roles/
# - policies/
# - irsa/
# ==================================

# -------------------------------
# Optional: Account context
# -------------------------------
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# -------------------------------
# Policies
# -------------------------------
# Loaded implicitly by Terraform
# files under policies/*.tf
# -------------------------------

# -------------------------------
# Roles
# -------------------------------
# Loaded implicitly by Terraform
# files under roles/*.tf
# -------------------------------

# -------------------------------
# IRSA (EKS only)
# -------------------------------
# IRSA resources depend on eks_oidc_url
# If EKS is not created yet, this module
# can be instantiated later or conditionally
# -------------------------------
