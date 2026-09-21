# ============================================================
# AWS LOAD BALANCER CONTROLLER - POD IDENTITY ASSOCIATION
# ============================================================

resource "aws_eks_pod_identity_association" "load_balancer_controller" {
  cluster_name = data.terraform_remote_state.eks.outputs.eks_cluster_name

  namespace       = var.namespace
  service_account = var.service_account_name

  role_arn = aws_iam_role.load_balancer_controller.arn

  tags = {
    Environment = var.environment_name
    Service     = "aws-load-balancer-controller"
    ManagedBy   = "terraform"
  }

  depends_on = [
    kubernetes_service_account_v1.load_balancer_controller,
    aws_iam_role_policy_attachment.load_balancer_controller
  ]
}
