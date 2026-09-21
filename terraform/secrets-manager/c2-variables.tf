# ==========================================
# AWS Lab - Shared Variables
# ==========================================

variable "aws_region" {
  description = "AWS Region for deployment"
  type        = string
  default     = "ca-central-1"
}

variable "awscli_user_profile" {
  description = "AWS CLI profile used to manage resources"
  type        = string
  default     = "dev-admin"
}

variable "environment_name" {
  description = "Environment name used for resource naming and tagging"
  type        = string
  default     = "dev"
}

variable "secrets" {
  description = "Secrets Manager secrets to create"
  type = map(object({
    description = string
  }))

  default = {}
}

variable "recovery_window_in_days" {
  description = "Number of days AWS Secrets Manager retains a deleted secret"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Common tags applied to managed resources"
  type        = map(string)

  default = {
    Terraform   = "true"
    Owner       = "Christian Onyeukwu"
    Environment = "dev"
  }
}
