variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ca-central-1"
}

variable "awscli_user_profile" {
  description = "AWS CLI profile used to manage the infrastructure"
  type        = string
  default     = "dev-admin"
}

variable "environment_name" {
  description = "Environment name used in resource names and tags"
  type        = string
  default     = "dev"
}

variable "ecr_repositories" {
  description = "ECR repositories managed by this Terraform stack"

  type = map(object({
    repository_name = string
    artifact_type   = optional(string, "Container")
    keep_versions   = optional(number, 20)
    tag_mutability  = optional(string, "IMMUTABLE")
    scan_on_push    = optional(bool, false)
    force_delete    = optional(bool, false)
  }))

  default = {}

  validation {
    condition = alltrue([
      for repository in values(var.ecr_repositories) :
      contains(["Container", "Helm"], repository.artifact_type)
    ])

    error_message = "artifact_type must be either Container or Helm."
  }
}

variable "common_tags" {
  description = "Common tags applied to every ECR repository"
  type        = map(string)

  default = {
    Project   = "aws-lab"
    ManagedBy = "Terraform"
  }
}
