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
variable "addon_version" {
  description = "EBS CSI Driver version"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to the EBS CSI add-on"
  type        = map(string)

  default = {
    Owner       = "Christian Onyeukwu"
    Project     = "EBS CSI Driver"
    Purpose     = "Persistent storage for EKS workloads"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
