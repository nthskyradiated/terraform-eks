resource "aws_iam_role" "pumpfactory-eks" {
  name = var.eks_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks" {
  role       = aws_iam_role.pumpfactory-eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "eks" {
  name     = var.eks_name
  version  = var.eks_version
  role_arn = aws_iam_role.pumpfactory-eks.arn
  vpc_config {
    subnet_ids = [
      aws_subnet.private_zone1.id,
      aws_subnet.private_zone2.id,
    ]
    endpoint_private_access = false
    endpoint_public_access  = true
  }
  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }
  depends_on = [aws_iam_role_policy_attachment.eks]
}