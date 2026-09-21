# ============================================================
# AWS Secrets Manager Outputs
# ============================================================

# ============================================================
# AWS Secrets Manager Outputs
# ============================================================

output "secret_arns" {
  description = "ARNs of Secrets Manager secrets"
  value = {
    for name, secret in aws_secretsmanager_secret.this :
    name => secret.arn
  }
}

output "secret_names" {
  description = "Names of Secrets Manager secrets"
  value = {
    for name, secret in aws_secretsmanager_secret.this :
    name => secret.name
  }
}

output "secret_ids" {
  description = "IDs of Secrets Manager secrets"
  value = {
    for name, secret in aws_secretsmanager_secret.this :
    name => secret.id
  }
}
