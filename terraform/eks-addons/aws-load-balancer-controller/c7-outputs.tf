# ============================================================
# AWS LOAD BALANCER CONTROLLER - OUTPUTS
# ============================================================

output "service_account_name" {
  description = "Kubernetes service account used by AWS Load Balancer Controller"
  value       = kubernetes_service_account_v1.load_balancer_controller.metadata[0].name
}

output "iam_role_name" {
  description = "IAM role used by AWS Load Balancer Controller"
  value       = aws_iam_role.load_balancer_controller.name
}

output "iam_role_arn" {
  description = "IAM role ARN used by AWS Load Balancer Controller"
  value       = aws_iam_role.load_balancer_controller.arn
}

output "pod_identity_association_id" {
  description = "EKS Pod Identity Association ID"
  value       = aws_eks_pod_identity_association.load_balancer_controller.association_id
}
