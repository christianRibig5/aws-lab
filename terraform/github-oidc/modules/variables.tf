variable "github_owner" {
  description = "GitHub user or organization that owns the repositories"
  type        = string
}

variable "repositories" {
  description = "Repository names permitted to assume the role"
  type        = set(string)

  validation {
    condition     = length(var.repositories) > 0
    error_message = "Provide at least one repository."
  }
}

variable "branches" {
  description = "Allowed GitHub branches"
  type        = set(string)
  default     = ["main"]
}

variable "environments" {
  description = "Allowed GitHub environment names"
  type        = set(string)
  default     = []
}

variable "repository_subject_prefixes" {
  description = "Optional immutable GitHub OIDC subject prefix keyed by repository name"
  type        = map(string)
  default     = {}
}

variable "role_name" {
  description = "Name of the IAM role assumed by GitHub Actions"
  type        = string
  default     = "github-actions-deployment-role"
}

variable "role_description" {
  description = "Description of the GitHub Actions IAM role"
  type        = string
  default     = "Short-lived AWS access for approved GitHub Actions workflows"
}

variable "create_oidc_provider" {
  description = "Create GitHub OIDC provider when true"
  type        = bool
  default     = true
}

variable "oidc_thumbprint_list" {
  description = "GitHub OIDC certificate thumbprints required by the AWS provider API"
  type        = list(string)

  default = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

variable "managed_policy_arns" {
  description = "Existing IAM managed policies to attach to the GitHub Actions role"
  type        = set(string)
  default     = []
}

variable "inline_policy_json" {
  description = "Optional least-privilege inline IAM policy"
  type        = string
  default     = null
}

variable "max_session_duration" {
  description = "Maximum IAM role session duration in seconds"
  type        = number
  default     = 3600

  validation {
    condition = (
      var.max_session_duration >= 3600 &&
      var.max_session_duration <= 43200
    )

    error_message = "max_session_duration must be between 3600 and 43200 seconds."
  }
}

variable "tags" {
  description = "Tags applied to IAM resources"
  type        = map(string)
  default     = {}
}

check "allowed_subjects" {
  assert {
    condition = (
      length(var.branches) +
      length(var.environments) > 0
    )

    error_message = "Permit at least one branch or GitHub environment."
  }
}
