variable "aws_region" {
  description = "AWS Region for deployment"
  type        = string
  default     = "ca-central-1"
}

variable "awscli_user_profile" {
  description = "AWS Profile Owner running the resources"
  type        = string
  default     = "dev-admin"
}

variable "environment_name" {
  description = "Environment name used in resource names and tags"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Global tags to apply to all resources"
  type        = map(string)

  default = {
    Terraform    = "true"
    Organization = "Jalex Solutions Inc"
    Owner        = "Christian Onyeukwu"
    Project      = "AWS Reusable DevOps Lab"
    Purpose      = "Terraform remote state backend"
  }
}

