# ============================================================
# Amazon ECR Repositories
# ============================================================
#
# Creates reusable ECR repositories for application container
# images, Helm OCI charts, or other supported OCI artifacts.
#
# Repository-specific configuration is supplied through
# terraform.tfvars rather than hard-coded in this file.
# ============================================================

module "ecr_repositories" {
  source = "./modules"

  for_each = var.ecr_repositories

  repository_name = each.value.repository_name

  artifact_type = each.value.artifact_type

  keep_versions  = each.value.keep_versions
  tag_mutability = each.value.tag_mutability
  scan_on_push   = each.value.scan_on_push
  force_delete   = each.value.force_delete

  tags = merge(
    var.common_tags,
    {
      Service     = each.key
      Environment = var.environment_name
    }
  )
}
