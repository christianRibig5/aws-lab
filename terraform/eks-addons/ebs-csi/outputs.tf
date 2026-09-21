# EBS CSI managed add-on

output "addon_name" {
  description = "Name of the EBS CSI managed EKS add-on"
  value       = aws_eks_addon.ebs_csi_driver.addon_name
}

output "addon_arn" {
  description = "ARN of the EBS CSI managed EKS add-on"
  value       = aws_eks_addon.ebs_csi_driver.arn
}

output "addon_version" {
  description = "Version of the EBS CSI managed EKS add-on"
  value       = aws_eks_addon.ebs_csi_driver.addon_version
}


# EBS CSI IAM role

output "ebs_csi_role_name" {
  description = "Name of the IAM role used by the EBS CSI controller"
  value       = aws_iam_role.ebs_csi.name
}

output "ebs_csi_role_arn" {
  description = "ARN of the IAM role used by the EBS CSI controller"
  value       = aws_iam_role.ebs_csi.arn
}


# EKS Pod Identity

output "pod_identity_association_id" {
  description = "ID of the EBS CSI Pod Identity association"
  value       = aws_eks_pod_identity_association.ebs_csi.association_id
}
