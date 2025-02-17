# * Make sure to remove the access keys from the eks users before destroying the resources.

resource "aws_iam_user" "developer" {
  name = "developer"
}

resource "aws_iam_policy" "developer_policy_eks" {
  name        = "developer_policy_eks"
  description = "Developer policy for EKS"
  policy      = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Action": [
            "eks:DescribeCluster",
            "eks:ListClusters"
        ],
        "Resource": "*"
        }
    ] 
}
    EOF
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