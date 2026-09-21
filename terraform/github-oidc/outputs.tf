output "github_actions_role_arn" {
  description = "ARN of the IAM role assumed by GitHub Actions"
  value       = module.github_actions_oidc.role_arn
}

output "github_actions_role_name" {
  description = "Name of the IAM role assumed by GitHub Actions"
  value       = module.github_actions_oidc.role_name
}

output "github_oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  value       = module.github_actions_oidc.oidc_provider_arn
}

output "github_oidc_allowed_subjects" {
  description = "GitHub OIDC subjects permitted to assume the IAM role"
  value       = module.github_actions_oidc.allowed_subjects
}
