output "pod_identity_agent_name" {
  description = "Name of the EKS Pod Identity Agent add-on"
  value       = aws_eks_addon.pod_identity_agent.addon_name
}

output "pod_identity_agent_version" {
  description = "Version of the EKS Pod Identity Agent add-on"
  value       = aws_eks_addon.pod_identity_agent.addon_version
}
