#---------------------------------------------------------------------------------------------
# local values used used throughout the  EKS configuration
# Helps to enforce naming consistency and reduce duplication
#-------------------------------------------------------------------------------------------------

locals {
  # Business division or team name 
  owners = var.business_division #eg retail

  # Environment name such as dev, prod, or staging
  environment = var.environment_name # eg dev

  # Standard nameing prefix
  name = "${local.owners}-${local.environment}" #eg retail-dev

  # Full EKS cliuster name used for resource naming and stagging
  eks_cluster_name = "${local.name}-${var.cluster_name}" #eg retail-dev-eks-demo
}
