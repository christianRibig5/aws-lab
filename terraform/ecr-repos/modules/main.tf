# ============================================================
# Amazon ECR Repository
# ============================================================

resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = var.tag_mutability
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = merge(
    var.tags,
    {
      Name         = var.repository_name
      ManagedBy    = "Terraform"
      ArtifactType = var.artifact_type
    }
  )
}


# ============================================================
# ECR Lifecycle Policy
# ============================================================
#
# Automatically removes older artifacts after the configured
# number of versions has been exceeded.
# ============================================================

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1

        description = "Keep only the newest ${var.keep_versions} versions"

        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.keep_versions
        }

        action = {
          type = "expire"
        }
      }
    ]
  })
}
