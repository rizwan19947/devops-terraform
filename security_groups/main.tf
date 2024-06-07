variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow PostgreSQL traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define security group for frontend load balancer
resource "aws_security_group" "frontend_lb_sg" {
  name        = "frontend-lb-sg"
  description = "Security group for frontend load balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define security group for backend load balancer
resource "aws_security_group" "backend_lb_sg" {
  name        = "backend-lb-sg"
  description = "Security group for backend load balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "frontend_lb_sg_id" {
  value = aws_security_group.frontend_lb_sg.id
}

output "backend_lb_sg_id" {
  value = aws_security_group.backend_lb_sg.id
}