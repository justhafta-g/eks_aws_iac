resource "aws_eip" "nat1" {
  # EIP depends on IGW, so terraform will check if IGW already created
  depends_on = [aws_internet_gateway.main]
}

resource "aws_eip" "nat2" {
  # EIP depends on IGW, so terraform will check if IGW already created
  depends_on = [aws_internet_gateway.main]
}