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

variable "github_owner" {
  description = "GitHub username or organization that owns the repositories"
  type        = string
}

variable "github_repositories" {
  description = "GitHub repositories permitted to assume the AWS IAM role"
  type        = set(string)

  validation {
    condition     = length(var.github_repositories) > 0
    error_message = "Provide at least one GitHub repository."
  }
}

variable "github_branches" {
  description = "GitHub branches permitted to assume the AWS IAM role"
  type        = set(string)
  default     = ["main"]
}

variable "repository_subject_prefixes" {
  description = "Optional immutable GitHub OIDC subject prefix for each repository"
  type        = map(string)
  default     = {}
}

variable "role_name" {
  description = "Name of the IAM role assumed by GitHub Actions"
  type        = string
  default     = "aws-lab-github-actions"
}

variable "create_oidc_provider" {
  description = "Whether Terraform should create the GitHub OIDC provider"
  type        = bool
  default     = true
}

variable "ecr_repository_arns" {
  description = "ECR repository ARNs GitHub Actions may access"
  type        = set(string)
  default     = []
}

variable "eks_cluster_arns" {
  description = "EKS cluster ARNs GitHub Actions may access"
  type        = set(string)
  default     = []
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
  description = "Tags applied to GitHub OIDC IAM resources"
  type        = map(string)

  default = {
    Environment = "dev"
    Owner       = "Christian Onyeukwu"
    Project     = "aws-lab"
    Terraform   = "true"
  }
}
