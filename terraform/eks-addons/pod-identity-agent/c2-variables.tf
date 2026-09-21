
variable "aws_region" {
  description = "AWS Region for deployment"
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

variable "tags" {
  description = "Global tags applied to supported resources"
  type        = map(string)

  default = {
    Terraform = "true"
    Owner     = "Christian Onyeukwu"
    Project   = "aws-lab"
    Purpose   = "EKS Pod Identity"
  }
}

