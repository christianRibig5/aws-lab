#-----------------------------------------------------------------
# AWS region used in provider block
#_________________________________________________________________
variable "aws_region" {
  description = "AWS Region for deployment"
  type        = string
  default     = "ca-central-1"
}

#-----------------------------------------------------------------
# AWSCLI User Profile (used as aws sso Login --profile devops)
#_________________________________________________________________
variable "awscli_user_profile" {
  description = "AWS Profile Owner running the resources"
  type        = string
  default     = "dev-admin"
}

#-----------------------------------------------------------------
# Environment & Business division Infor
#_________________________________________________________________

# Logical Environment Name (used in tags and resource names)
variable "environment_name" {
  description = "Environment name used in resource names and tags"
  type        = string
  default     = "dev"
}

# Business unit or department (used in tags or naming)
variable "business_division" {
  description = "Business division in the large organisation this infrastructure belongs"
  type        = string
  default     = "retail"
}

#-----------------------------------------------------------------
# EKS Cluster Configuration
#_________________________________________________________________

# Name of the EKS Cluster (used in tags and names, and refereneces)
variable "cluster_name" {
  description = "Name of the EKS Cluster. Also used as a prefix in name of the related resources"
  type        = string
  default     = "eksjalexsol"
}

variable "cluster_version" {
  description = "Kubernetes minor version to use for EKS Cluster(eg. 1.28, 1.29)"
  type        = string
  default     = null

}

# CIDR Block used for kubernetes service networking
variable "cluster_service_ipv4_cidr" {
  description = "Service CIDR range for kubernetes service. (Optional leave if null to AWS default)"
  type        = string
  default     = null
}

# Enable access to EKS API Cluster via private endpoint
variable "cluster_endpoint_private_access" {
  description = "whether to enable private access to EKS control plane endpoint"
  type        = bool
  default     = false
}

# Enable access to EKS API Cluster via public endpoint
variable "cluster_endpoint_public_access" {
  description = "whether to enable public access to EKS control plane"
  type        = bool
  default     = true
}

# List of CIDRs allow to reach the public EKS API endpoint
variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks allow to access public EKS endpoints"
  type        = list(string)
  default     = ["0.0.0.0/0"]

}

#-----------------------------------------------------------------
# # Common Tags
#_________________________________________________________________

# Tags Applied to all resources 
variable "tags" {
  description = "Global tags to apply to EKS and related resources"
  type        = map(string)
  default = {
    Terraform    = "true"
    Owner        = "Christian Onyeukwu"
    Organization = "JALEX Solutions Inc"
  }
}
#-----------------------------------------------------------------
# EKS Node Group Configuration
#_________________________________________________________________

# EC2 instance type for worker nodes
variable "node_instance_types" {
  description = "List of EC2 instance types for the node grouops"
  type        = list(string)
  default     = ["t3.medium"]
}

#Capacity type for node group (ON_DEMAND or SPOT)
variable "node_capacity_type" {
  description = "Instance capacity type: ON_DEMAND or SPOT"
  type        = string
  default     = "ON_DEMAND"
}

#Root volume size for worker node in GiB
variable "node_disk_size" {
  description = "Disk size in GiB for worker nodes"
  type        = number
  default     = 20
}
# Desired number of worker nodes to run in the EKS node group
# This is the target node count Terraform will try to maintain
variable "node_desired_size" {
  description = "Desired number of worker nodes in the EKS node group"
  type        = number
  default     = 3
}

# Minimum number of worker nodes the node group is allowed to scale down to
# Keep this at 3 for this lab so core workloads can still schedule
variable "node_min_size" {
  description = "Minimum number of worker nodes in the EKS node group"
  type        = number
  default     = 1
}

# Maximum number of worker nodes the node group can scale up to
# Leave some headroom above desired size for temporary scaling if needed
variable "node_max_size" {
  description = "Maximum number of worker nodes in the EKS node group"
  type        = number
  default     = 6
}

