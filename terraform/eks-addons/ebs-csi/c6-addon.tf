# Amazon EBS CSI Driver managed EKS add-on

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name = data.terraform_remote_state.eks.outputs.eks_cluster_name

  addon_name    = "aws-ebs-csi-driver"
  addon_version = var.addon_version

  namespace_config {
    namespace = "kube-system"
  }

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = merge(
    var.tags,
    {
      Component = "ebs-csi"
    }
  )

  # Ensure AWS identity is ready before installing the driver.
  depends_on = [
    aws_eks_pod_identity_association.ebs_csi
  ]
}

