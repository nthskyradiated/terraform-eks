resource "aws_efs_file_system" "eks" {
  creation_token = "eks"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = true
}

resource "aws_efs_mount_target" "zone_a" {
  file_system_id  = aws_efs_file_system.eks.id
  subnet_id       = var.private_subnet_ids[0]
  security_groups = [var.cluster_security_group_id]
}

resource "aws_efs_mount_target" "zone_b" {
  file_system_id  = aws_efs_file_system.eks.id
  subnet_id       = var.private_subnet_ids[1]
  security_groups = [var.cluster_security_group_id]
}

resource "aws_iam_role" "efs_csi" {
  name = "efs-csi-${var.shared.eks_cluster_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.shared.oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${trimprefix(var.shared.oidc_provider_url, "https://")}:sub": "system:serviceaccount:kube-system:efs-csi-controller-sa"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "efs_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSEFSCSIDriverPolicy"
  role       = aws_iam_role.efs_csi.name
}

resource "helm_release" "aws_efs_csi_driver" {
  name       = "aws-efs-csi-driver"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  chart      = "aws-efs-csi-driver"
  version    = "2.5.1"

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.efs_csi.arn
  }

  set {
    name  = "controller.serviceAccount.name"
    value = "efs-csi-controller-sa"
  }
}

resource "kubernetes_storage_class_v1" "efs" {
  metadata {
    name = "efs"
  }

  storage_provisioner = "efs.csi.aws.com"

  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = aws_efs_file_system.eks.id
    directoryPerms   = "700"
  }

  mount_options = ["iam"]

  depends_on = [helm_release.aws_efs_csi_driver]
}
