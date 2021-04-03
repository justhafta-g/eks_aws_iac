resource "aws_iam_role" "nodes_general" {
  name = var.nodes_group_name

  # The policy that grants an entity permission to assume the role
  assume_role_policy = <<POLICY
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
POLICY
}

resource "aws_iam_role_policy_attachment" "aws_eks_worker_node_policy_general" {
  # The ARN of the policy that we want to apply, that role gives as a lot of accesses
  # https://github.com/SummitRoute/aws_managed_policies/blob/master/policies/AmazonEKSWorkerNodePolicy
  policy_arn = "arn:aws:iam:policy/AmazonEKSWorkerNodePolicy"

  #Role policy should be applied to

  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "aws_eks_cni_policy_general" {
  # The ARN of the policy that we want to apply, that role gives as a lot of accesses
  # https://github.com/SummitRoute/aws_managed_policies/blob/master/policies/AmazonEKS_CNI_Policy
  policy_arn = "arn:aws:iam:policy/AmazonEKS_CNI_Policy"

  #Role policy should be applied to

  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "aws_eks_ec2_container_registry_policy_general" {
  # The ARN of the policy that we want to apply, that role gives as a lot of accesses
  # https://github.com/SummitRoute/aws_managed_policies/blob/master/policies/AmazonEC2ContainerRegistryReadOnly
  policy_arn = "arn:aws:iam:policy/AmazonEC2ContainerRegistryReadOnly"

  #Role policy should be applied to

  role = aws_iam_role.nodes_general.name
}

resource "aws_eks_node_group" "nodes_general" {
  # Name of the EKS cluster
  cluster_name = aws_eks_cluster.eks.name

  # Name of the EKS Node Group
  node_group_name = var.nodes_group_name

  # Amazon ARN of the IAM Role
  node_role_arn = aws_iam_role.nodes_general.arn

  # Identifiers of EC2 Subnets to associate with the EKS Node Group
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  # Configuration block with scaling settings
  scaling_config {
    # Number of worker nodes
    desired_size = 1

    # Max number of worker nodes
    max_size = 1

    # Max number of worker nodes
    min_size = 1
  }

  # type of Amazon Machine Image (AMI) associated with EKS Node Group
  # Values: AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64
  ami_type = "AL2_x86_64"

  # Type of capacity with the EKS Node Group
  # Values: ON_DEMAND, SPOT (much chiper but may be lost)
  capacity_type = "SPOT"

  # Disk size in GiB for worker nodes
  disk_size = 20

  # FForce version update if existing pods are unable to be drained due to a pod disruption pod issues
  force_update_version = false

  # List of instace types
  instance_types = ["t3.small"]

  labels = {
    "role" = "nodes-general"
  }

  # K8s version
  version = "1.19"

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EKS EC2 Instances and Elastic Network IP.
  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_worker_node_policy_general,
    aws_iam_role_policy_attachment.aws_eks_cni_policy_general,
    aws_iam_role_policy_attachment.aws_eks_ec2_container_registry_policy_general,
  ]
}