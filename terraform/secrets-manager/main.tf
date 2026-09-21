# ============================================================
# Generic AWS Secrets Manager Secret
# Reusable across applications and infrastructure components
# ============================================================

resource "aws_secretsmanager_secret" "this" {
  for_each = var.secrets

  name        = "${var.environment_name}/${each.key}"
  description = each.value.description

  recovery_window_in_days = var.recovery_window_in_days

  tags = merge(
    var.tags,
    {
      Name        = each.key
      Environment = var.environment_name
    }
  )
}
