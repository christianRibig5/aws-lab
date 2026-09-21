output "role_arn" {
  description = "IAM role ARN used as role-to-assume by GitHub Actions"
  value       = aws_iam_role.github_actions.arn
}

output "role_name" {
  description = "IAM role name"
  value       = aws_iam_role.github_actions.name
}

output "oidc_provider_arn" {
  description = "GitHub OIDC provider ARN"
  value       = local.oidc_provider_arn
}

output "allowed_subjects" {
  description = "GitHub OIDC subjects trusted by the IAM role"
  value       = local.allowed_subjects
}
