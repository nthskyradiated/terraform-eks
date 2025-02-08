resource "aws_iam_role" "pumpfactory-nodes" {
  name = "pumpfactory-nodes-${local.eks_name}-${local.env}"
  assume_role_policy = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": [
      {
      "Effect": "Allow",
      "Principal": {
          "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
      }
  ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.pumpfactory-nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.pumpfactory-nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_read_only" {
  role       = aws_iam_role.pumpfactory-nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_node_group" "general" {
  cluster_name = aws_eks_cluster.eks.name
    node_group_name = "general"
    version = local.eks_version
    node_role_arn = aws_iam_role.pumpfactory-nodes.arn

    subnet_ids = [
        aws_subnet.pumpfactory-subnet-private-1.id,
        aws_subnet.pumpfactory-subnet-private-2.id,
    ]
capacity_type = "SPOT"
instance_types = ["t2.micro"] 
    scaling_config {
        desired_size = 1
        max_size     = 3
        min_size     = 0
    }
update_config {
  max_unavailable = 1
}
labels = {
    role = "general"
}
    depends_on = [
        aws_iam_role_policy_attachment.eks_worker_node_policy,
        aws_iam_role_policy_attachment.eks_cni_policy,
        aws_iam_role_policy_attachment.ec2_container_registry_read_only,
    ]
lifecycle {
    ignore_changes = [ scaling_config[0].desired_size ]
}
}