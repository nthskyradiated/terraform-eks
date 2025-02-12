output "cluster_name" {
  value       = aws_eks_cluster.eks.name
  description = "Name of the EKS cluster"
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.eks.endpoint
  description = "Endpoint for EKS control plane"
}

output "cluster_security_group_id" {
  value       = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
  description = "Security group ID of the cluster control plane"
}

output "cluster_certificate_authority_data" {
  value       = aws_eks_cluster.eks.certificate_authority[0].data
  description = "Base64 encoded certificate data for the cluster"
}

output "oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.eks.arn
  description = "ARN of the OIDC Provider"
}

output "oidc_provider_url" {
  value       = aws_iam_openid_connect_provider.eks.url
  description = "URL of the OIDC Provider"
}

output "node_group_role_arn" {
  value       = aws_iam_role.node_group.arn
  description = "ARN of the node group IAM role"
}
