# * Make sure to remove the access keys from the eks users before destroying the resources.

data "aws_caller_identity" "current" {}

# Admin Role
resource "aws_iam_role" "eks_admin" {
  name = "${var.eks_cluster_name}-eksadmin"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
    }]
  })
}

resource "aws_iam_policy" "eks_admin_policy" {
  name   = "${var.eks_cluster_name}-admin-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["eks:*"],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = "iam:PassRole",
        Resource = "*",
        Condition = {
          StringEquals = {
            "iam:PassedToService": "eks.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_admin_policy_attachment" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = aws_iam_policy.eks_admin_policy.arn
}

resource "aws_iam_user" "eksadmin" {
  name = "eksadmin"
}

resource "aws_iam_policy" "eks_assume_admin" {
  name   = "eks_assume_admin"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["sts:AssumeRole"],
        Resource = "${aws_iam_role.eks_admin.arn}"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "eks_assume_admin_policy_attachment" {
  user       = aws_iam_user.eksadmin.name
  policy_arn = aws_iam_policy.eks_assume_admin.arn
}

resource "aws_eks_access_entry" "eks_admin" {
  cluster_name      = aws_eks_cluster.eks.name
  principal_arn     = aws_iam_role.eks_admin.arn
  kubernetes_groups = ["my-admin"]
}

resource "aws_iam_user" "developer" {
  name = "developer"
}

resource "aws_iam_policy" "developer_policy_eks" {
  name        = "developer_policy_eks"
  description = "Developer policy for EKS"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["eks:DescribeCluster", "eks:ListClusters"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "developer_policy_eks" {
  user       = aws_iam_user.developer.name
  policy_arn = aws_iam_policy.developer_policy_eks.arn
}

resource "aws_eks_access_entry" "developer" {
  cluster_name      = aws_eks_cluster.eks.name
  principal_arn     = aws_iam_user.developer.arn
  kubernetes_groups = ["my-viewer"]
}


