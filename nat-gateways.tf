resource "aws_nat_gateway" "gw1" {
  # Allocation ID of EIP for the gateway
  allocation_id = aws_eip.nat1.id

  # Subnet ID of the subnet in which to place gateway
  subnet_id = aws_subnet.public_1.id

  tags = {
    "Name" = "NAT 1"
  }
}

resource "aws_nat_gateway" "gw2" {
  # Allocation ID of EIP for the gateway
  allocation_id = aws_eip.nat2.id

  # Subnet ID of the subnet in which to place gateway
  subnet_id = aws_subnet.public_2.id

  tags = {
    "Name" = "NAT 2"
  }
}