output "ebs_csi_driver_role_arn" {
  value       = aws_iam_role.ebs_csi.arn
  description = "ARN of the IAM role for EBS CSI driver"
}
