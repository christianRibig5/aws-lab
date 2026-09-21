terraform {
  required_version = ">=1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0"
    }
  }
  # ============================================================
  # REMOTE TERRAFORM BACKEND
  # Stores this stack's Terraform state centrally in S3 instead
  # of on this computer. The state records what Terraform manages
  # and enables safe, consistent infrastructure operations.
  #
  # Each lab component uses a unique S3 key to keep states isolated.
  # use_lockfile prevents concurrent Terraform operations.
  # ============================================================
  backend "s3" {
    bucket       = "tfstate-dev-ca-central-1-i1zfl3al"
    key          = "eks-addons/ebs-csi/dev/terraform.tfstate"
    region       = "ca-central-1"
    encrypt      = true
    use_lockfile = true
  }

}

provider "aws" {
  region  = var.aws_region
  profile = var.awscli_user_profile
}
