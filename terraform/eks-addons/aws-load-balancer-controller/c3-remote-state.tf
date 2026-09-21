# ============================================================
# REMOTE STATE - EKS
# ============================================================
# Reads outputs from the existing EKS Terraform state.
# ============================================================

data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket  = "tfstate-dev-ca-central-1-i1zfl3al"
    key     = "eks/dev/terraform.tfstate"
    region  = var.aws_region
    profile = var.aws_profile
  }
}

# ============================================================
# EKS CLUSTER DATA
# ============================================================

data "aws_eks_cluster" "this" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_name
}
