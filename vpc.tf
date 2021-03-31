resource "aws_vpc" "main" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"

  #Required for EKS. Need to be true.
  enable_dns_support = true

  #Required for EKS. Need to be true.
  enable_dns_hostnames = true

  enable_classiclink               = false
  enable_classiclink_dns_support   = false
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "main"
  }
}