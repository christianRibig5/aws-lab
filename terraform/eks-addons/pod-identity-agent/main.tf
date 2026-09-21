
resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = data.terraform_remote_state.eks.outputs.eks_cluster_name
  addon_name   = "eks-pod-identity-agent"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = merge(
    var.tags,
    {
      Environment = var.environment_name
      Component   = "eks-pod-identity-agent"
    }
  )
}




