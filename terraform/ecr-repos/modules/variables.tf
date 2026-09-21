variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "artifact_type" {
  description = "Type of artifact stored in the repository"
  type        = string
  default     = "Container"

  validation {
    condition = contains(
      ["Container", "Helm"],
      var.artifact_type
    )

    error_message = "artifact_type must be either Container or Helm."
  }
}

variable "tag_mutability" {
  description = "Whether existing image tags may be overwritten"
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition = contains(
      ["MUTABLE", "IMMUTABLE"],
      var.tag_mutability
    )

    error_message = "tag_mutability must be MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  description = "Enable basic image scanning when artifacts are pushed"
  type        = bool
  default     = false
}

variable "keep_versions" {
  description = "Number of artifact versions to retain"
  type        = number
  default     = 20

  validation {
    condition     = var.keep_versions > 0
    error_message = "keep_versions must be greater than zero."
  }
}

variable "force_delete" {
  description = "Allow Terraform to delete a repository containing artifacts"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to the ECR repository"
  type        = map(string)
  default     = {}
}
