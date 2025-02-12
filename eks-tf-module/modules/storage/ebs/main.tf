data "aws_iam_policy_document" "ebs_csi_driver" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "ebs_csi" {
  name               = "ebs-csi-${var.shared.eks_cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_driver.json
}

resource "aws_iam_role_policy_attachment" "ebs_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi.name
}

# Optional: EBS encryption policy
resource "aws_iam_policy" "ebs_encryption" {
  name = "${var.shared.eks_cluster_name}-ebs-csi-driver-encryption"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKeyWithoutPlaintext",
          "kms:CreateGrant"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_encryption" {
  policy_arn = aws_iam_policy.ebs_encryption.arn
  role       = aws_iam_role.ebs_csi.name
}

resource "aws_eks_pod_identity_association" "ebs_csi" {
  cluster_name    = var.shared.eks_cluster_name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa"
  role_arn        = aws_iam_role.ebs_csi.arn
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name             = var.shared.eks_cluster_name
  addon_name              = "aws-ebs-csi-driver"
  addon_version           = "v1.38.1-eksbuild.2"
  service_account_role_arn = aws_iam_role.ebs_csi.arn
}
