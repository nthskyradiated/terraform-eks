output "efs_csi_driver_role_arn" {
  value       = aws_iam_role.efs_csi.arn
  description = "ARN of the IAM role for EFS CSI driver"
}
