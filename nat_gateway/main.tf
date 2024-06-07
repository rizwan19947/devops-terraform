variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(var.public_subnets, 0)
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}
