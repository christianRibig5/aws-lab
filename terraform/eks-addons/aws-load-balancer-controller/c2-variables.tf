# ============================================================
# AWS LOAD BALANCER CONTROLLER - VARIABLES
# ============================================================

variable "aws_region" {
  description = "AWS region where the EKS cluster is deployed"
  type        = string
  default     = "ca-central-1"
}

variable "aws_profile" {
  description = "AWS CLI profile used by Terraform"
  type        = string
  default     = "dev-admin"
}

variable "environment_name" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "retail-dev-eksjalexsol"
}

variable "namespace" {
  description = "Kubernetes namespace for AWS Load Balancer Controller"
  type        = string
  default     = "kube-system"
}

variable "service_account_name" {
  description = "Kubernetes service account used by AWS Load Balancer Controller"
  type        = string
  default     = "aws-load-balancer-controller-sa"
}
