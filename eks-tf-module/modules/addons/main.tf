# Pod Identity Addon
resource "aws_eks_addon" "pod_identity" {
  cluster_name  = var.shared.eks_cluster_name
  addon_name    = "eks-pod-identity-agent"
  addon_version = "v1.3.4-eksbuild.1"
}

# Cluster Autoscaler
resource "aws_iam_role" "cluster_autoscaler" {
  name = "${var.shared.eks_cluster_name}-autoscaler"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "pods.eks.amazonaws.com"
      }
      Action = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
    }]
  })
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name = "${aws_eks_cluster.eks.name}-autoscaler"
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "autoscaling:DescribeAutoScalingGroups",
            "autoscaling:DescribeAutoScalingInstances",
            "autoscaling:DescribeLaunchConfigurations",
            "autoscaling:DescribeTags",
            "autoscaling:DescribeScalingActivities",
            "ec2:DescribeInstanceTypes",
            "ec2:DescribeLaunchTemplateVersions",
            "ec2:GetInstanceTypesFromInstanceRequirements",
            "ec2:DescribeImages",
            "ec2:DescribeNodeGroups",
          ]
          Resource = "*"
        },
        {
          Effect = "Allow"
          Action = [
            "autoscaling:SetDesiredCapacity",
            "autoscaling:TerminateInstanceInAutoScalingGroup"
          ]
          Resource = "*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  role       = aws_iam_role.cluster_autoscaler.name
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
}

resource "aws_eks_pod_identity_association" "cluster_autoscaler" {
  cluster_name    = aws_eks_cluster.eks.name
  namespace       = "kube-system"
  service_account = "cluster-autoscaler"
  role_arn        = aws_iam_role.cluster_autoscaler.arn
}

resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = "3.12.2"
  timeout    = var.helm_timeout

  set {
    name  = "args[0]"
    value = "--kubelet-insecure-tls"
  }

  values = [file("${path.module}/values/metrics-server.yaml")]

  depends_on = [aws_eks_node_group.general]
}

resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = "9.46.0"
  timeout    = var.helm_timeout

  set {
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }
  set {
    name  = "autoDiscovery.clusterName"
    value = aws_eks_cluster.eks.name
  }
  set {
    name  = "awsRegion"
    value = var.shared.region
  }

  depends_on = [helm_release.metrics_server]
}

resource "helm_release" "secrets_csi_driver" {
  name       = "secrets-store-csi-driver"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  namespace  = var.secrets_namespace
  version    = "1.4.8"
  timeout    = var.helm_timeout

  set {
    name  = "syncSecret.enabled"
    value = true
  }

  depends_on = [helm_release.cluster_autoscaler]
}

resource "helm_release" "secrets_csi_driver_aws_provider" {
  name       = "secrets-store-csi-driver-provider-aws"
  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  namespace  = var.secrets_namespace
  version    = "0.3.11"
  timeout    = var.helm_timeout

  depends_on = [helm_release.secrets_csi_driver]
}

data "aws_iam_policy_document" "myapp_secrets" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${trimprefix(var.shared.oidc_provider_url, "https://")}:sub"
      values   = ["system:serviceaccount:default:myapp"]
    }

    principals {
      identifiers = [var.shared.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "myapp_secrets" {
  name               = "${var.shared.eks_cluster_name}-myapp-secrets"
  assume_role_policy = data.aws_iam_policy_document.myapp_secrets.json
}

resource "aws_iam_policy" "myapp_secrets" {
  name = "${aws_eks_cluster.eks.name}-myapp-secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "*" # "arn:*:secretsmanager:*:*:secret:my-secret-kkargS"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "myapp_secrets" {
  policy_arn = aws_iam_policy.myapp_secrets.arn
  role       = aws_iam_role.myapp_secrets.name
}

output "myapp_secrets_role_arn" {
  value = aws_iam_role.myapp_secrets.arn
}