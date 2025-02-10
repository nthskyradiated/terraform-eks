# * Make sure to remove the access keys from the eks users before destroying the resources.

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "eks_admin" {
  name               = "${local.eks_name}-eksadmin"
  assume_role_policy = <<EOF
 {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            }
        }
    ]
 }
 EOF
}

resource "aws_iam_policy" "eks_admin_policy" {
  name   = "${local.eks_name}-admin-policy"
  policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": ["eks:*"],
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": "iam:PassRole",
                "Resource": "*",
                "Condition": {
                    "StringEquals": {
                        "iam:PassedToService": "eks.amazonaws.com"
                    }
                }
            }
        ]
    }
    EOF
}

resource "aws_iam_role_policy_attachment" "eks_admin_policy" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = aws_iam_policy.eks_admin_policy.arn
}

resource "aws_iam_user" "eksadmin" {
  name = "eksadmin"

}

resource "aws_iam_policy" "eks_assume_admin" {
  name   = "eks_assume_admin"
  policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "sts:AssumeRole",
                "Resource": "${aws_iam_role.eks_admin.arn}"
            }
        ]
    }
    EOF
}

resource "aws_iam_user_policy_attachment" "eks_assume_admin" {
  user       = aws_iam_user.eksadmin.name
  policy_arn = aws_iam_policy.eks_assume_admin.arn
}

resource "aws_eks_access_entry" "eks_admin" {
  cluster_name      = aws_eks_cluster.eks.name
  principal_arn     = aws_iam_user.eksadmin.arn
  kubernetes_groups = ["my-admin"]

}