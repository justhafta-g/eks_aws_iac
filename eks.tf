resource "aws_iam_role" "eks_cluster" {
  name = var.cluster_name

  # The policy that grants an entity permission to assume the role
  # Used to access AWS resources that not normally have access to
  # The role that AWS EKS will use to create AWS resources for K8S clusters
  # Principal - subject who will be use this role 
  #First step
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

#Second step
resource "aws_iam_role_policy_attachment" "aws_eks_cluster_policy" {
  # The ARN of the policy that we want to apply, that role gives as a lot of accesses
  # https://github.com/SummitRoute/aws_managed_policies/blob/master/policies/AmazonEKSClusterPolicy
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

  #Role policy should be applied to

  role = aws_iam_role.eks_cluster.name
}

# RESOURCE: aws_eks_cluster
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster
resource "aws_eks_cluster" "eks" {
  name = "eks"

  # the Amazon Resource Name (ARN) of the IAM role that provides permissions for the K8S control plane
  # to make calls to AWS API operations on your behalf
  role_arn = aws_iam_role.eks_cluster.arn

  # Desired K8S master version
  version = "1.19"

  vpc_config {
    # Amazon EKS private API server endpoint is enabled
    endpoint_private_access = false

    # Amazon EKS public API server endpoint is enabled 
    endpoint_public_access = true

    subnet_ids = [
      aws_subnet.public_1.id,
      aws_subnet.public_2.id,
      aws_subnet.private_1.id,
      aws_subnet.private_2.id
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_cluster_policy,
  ]
}
