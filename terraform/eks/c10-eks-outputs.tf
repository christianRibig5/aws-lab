# EKS cluster connection details

output "eks_cluster_endpoint" {
  description = "EKS API server endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "eks_cluster_id" {
  description = "Name/ID of the EKS cluster"
  value       = aws_eks_cluster.main.id
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "eks_cluster_version" {
  description = "Kubernetes version running on the EKS cluster"
  value       = aws_eks_cluster.main.version
}

output "eks_cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data for the EKS cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}


# Node group

output "private_node_group_name" {
  description = "Name of the private EKS managed node group"
  value       = aws_eks_node_group.private_nodes.node_group_name
}

output "eks_node_instance_role_arn" {
  description = "IAM role ARN used by the EKS worker nodes"
  value       = aws_iam_role.eks_nodegroup_role.arn
}


# Networking

output "eks_cluster_security_group_id" {
  description = "Security group ID associated with the EKS cluster"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}


# Operational helper

output "to_configure_kubectl" {
  description = "AWS CLI command for configuring kubectl access to the cluster"
  value       = "aws eks --region ${var.aws_region} update-kubeconfig --name ${local.eks_cluster_name}"
}
