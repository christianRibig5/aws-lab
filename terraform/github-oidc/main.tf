# ============================================================
# GitHub Actions AWS Permissions
# ============================================================
#
# This policy defines what GitHub Actions is allowed to do
# after successfully assuming the AWS IAM role through OIDC.
#
# Permissions are created only when the corresponding AWS
# resources are supplied through Terraform variables.
# ============================================================

data "aws_iam_policy_document" "github_permissions" {

  # ----------------------------------------------------------
  # ECR Authentication
  # ----------------------------------------------------------
  #
  # Required for GitHub Actions to authenticate to Amazon ECR.
  # Created only when at least one ECR repository ARN is
  # configured.
  # ----------------------------------------------------------

  dynamic "statement" {
    for_each = length(var.ecr_repository_arns) > 0 ? [1] : []

    content {
      sid       = "EcrAuthentication"
      effect    = "Allow"
      actions   = ["ecr:GetAuthorizationToken"]
      resources = ["*"]
    }
  }


  # ----------------------------------------------------------
  # ECR Push / Pull Permissions
  # ----------------------------------------------------------
  #
  # Allows GitHub Actions to push and pull container images
  # only from the explicitly configured ECR repositories.
  # ----------------------------------------------------------

  dynamic "statement" {
    for_each = length(var.ecr_repository_arns) > 0 ? [1] : []

    content {
      sid    = "EcrPushPull"
      effect = "Allow"

      actions = [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:GetDownloadUrlForLayer",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ]

      resources = var.ecr_repository_arns
    }
  }


  # ----------------------------------------------------------
  # EKS Permissions
  # ----------------------------------------------------------
  #
  # Allows GitHub Actions to describe explicitly configured
  # EKS clusters.
  #
  # No EKS permission is created when the list is empty.
  # ----------------------------------------------------------

  dynamic "statement" {
    for_each = length(var.eks_cluster_arns) > 0 ? [1] : []

    content {
      sid       = "DescribeEksCluster"
      effect    = "Allow"
      actions   = ["eks:DescribeCluster"]
      resources = var.eks_cluster_arns
    }
  }
}


# ============================================================
# Reusable GitHub Actions OIDC Module
# ============================================================
#
# The module manages:
#
# - GitHub OIDC provider
# - IAM trust relationship
# - GitHub Actions IAM role
# - Immutable/default GitHub OIDC subjects
# - Optional IAM permissions
#
# Repository-specific information remains outside the module
# and is supplied through terraform.tfvars.
# ============================================================

module "github_actions_oidc" {
  source = "./modules"

  # GitHub account or organization
  github_owner = var.github_owner

  # Repositories permitted to assume the AWS role
  repositories = var.github_repositories

  # Branches permitted to assume the AWS role
  branches = var.github_branches

  # GitHub immutable OIDC subject prefixes.
  #
  # Example:
  # repo:OWNER@OWNER-ID/REPOSITORY@REPOSITORY-ID
  #
  # This allows different repositories/projects to use their
  # own GitHub immutable identity without hard-coding repository
  # information inside the reusable module.
  repository_subject_prefixes = var.repository_subject_prefixes

  # IAM role assumed by GitHub Actions
  role_name = var.role_name

  # Create the account-level GitHub OIDC provider when required
  create_oidc_provider = var.create_oidc_provider

  # Least-privilege AWS permissions generated above
  inline_policy_json = data.aws_iam_policy_document.github_permissions.json

  # Maximum AWS role session duration
  max_session_duration = var.max_session_duration

  # Standard resource tags
  tags = var.tags
}
