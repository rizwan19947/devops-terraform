variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of Availability Zones to distribute the subnets across"
  type        = list(string)
}

resource "aws_subnet" "public" {
  count                   = 3
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet("10.0.0.0/16", 4, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(var.availability_zones, count.index)
}

resource "aws_subnet" "private" {
  count             = 3
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet("10.0.0.0/16", 4, count.index + 3)
  availability_zone = element(var.availability_zones, count.index)
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}
