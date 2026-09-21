data "aws_caller_identity" "current" {}

locals {

  # GitHub OIDC provider ARN.
  # If Terraform creates the provider, use the created resource.
  # Otherwise construct the ARN for an existing provider.
  oidc_provider_arn = var.create_oidc_provider ? (
    aws_iam_openid_connect_provider.github[0].arn
    ) : (
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
  )

  # Determine the correct OIDC subject prefix for every repository.
  #
  # Immutable GitHub repositories:
  # repo:OWNER@OWNER-ID/REPOSITORY@REPOSITORY-ID
  #
  # Traditional/default repositories:
  # repo:OWNER/REPOSITORY
  #
  # No repository name is hard-coded in this module.
  repository_prefixes = {
    for repository in var.repositories :
    repository => lookup(
      var.repository_subject_prefixes,
      repository,
      "repo:${var.github_owner}/${repository}"
    )
  }

  # Trust approved repository + branch combinations.
  branch_subjects = flatten([
    for repository in var.repositories : [
      for branch in var.branches :
      "${local.repository_prefixes[repository]}:ref:refs/heads/${branch}"
    ]
  ])

  # Trust approved GitHub environments when configured.
  environment_subjects = flatten([
    for repository in var.repositories : [
      for environment in var.environments :
      "${local.repository_prefixes[repository]}:environment:${environment}"
    ]
  ])

  allowed_subjects = concat(
    local.branch_subjects,
    local.environment_subjects
  )
}


# ---------------------------------------------------------
# GitHub OIDC Provider
# ---------------------------------------------------------

resource "aws_iam_openid_connect_provider" "github" {
  count = var.create_oidc_provider ? 1 : 0

  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = var.oidc_thumbprint_list

  tags = var.tags
}


# ---------------------------------------------------------
# GitHub Actions IAM Trust Policy
# ---------------------------------------------------------

data "aws_iam_policy_document" "trust" {

  statement {
    sid     = "GitHubActionsAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"

      identifiers = [
        local.oidc_provider_arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"

      values = local.allowed_subjects
    }
  }
}


# ---------------------------------------------------------
# GitHub Actions IAM Role
# ---------------------------------------------------------

resource "aws_iam_role" "github_actions" {
  name                 = var.role_name
  description          = var.role_description
  assume_role_policy   = data.aws_iam_policy_document.trust.json
  max_session_duration = var.max_session_duration

  tags = var.tags
}


# ---------------------------------------------------------
# Optional Managed IAM Policies
# ---------------------------------------------------------

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.github_actions.name
  policy_arn = each.value
}


# ---------------------------------------------------------
# Optional Inline Least-Privilege Policy
# ---------------------------------------------------------

resource "aws_iam_role_policy" "inline" {
  count = var.inline_policy_json != null ? 1 : 0

  name   = "${var.role_name}-permissions"
  role   = aws_iam_role.github_actions.id
  policy = var.inline_policy_json
}
