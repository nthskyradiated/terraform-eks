output "pod_identity_addon_version" {
  value       = aws_eks_addon.pod_identity.addon_version
  description = "Version of the Pod Identity addon"
}

output "cluster_autoscaler_role_arn" {
  value       = aws_iam_role.cluster_autoscaler.arn
  description = "ARN of the Cluster Autoscaler IAM role"
}

output "secrets_role_arn" {
  value       = aws_iam_role.myapp_secrets.arn
  description = "ARN of the Secrets Store CSI Driver IAM role"
}

output "metrics_server_status" {
  value       = helm_release.metrics_server.status
  description = "Status of the metrics server deployment"
}
