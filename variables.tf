variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "cluster_name" {
  default = "webapp-eks"
}

variable "profile" {
  default = "default"
}

variable "nodes_group_name" {
  default = "eks-node-group-general"
}