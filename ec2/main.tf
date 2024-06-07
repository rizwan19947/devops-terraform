variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "frontend_lb_sg_id" {
  description = "Security Group ID for EC2 instances"
  type        = string
}

variable "backend_lb_sg_id" {
  description = "Security Group ID for EC2 instances"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

resource "aws_instance" "backend" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  subnet_id     = element(var.private_subnets, 0)
  key_name      = "tf_user_2_new"
  user_data = templatefile("${path.module}/userdata.sh", {})
  # Attach the Security Group
  vpc_security_group_ids = [var.backend_lb_sg_id]

  tags = {
    Name = "Backend"
  }
}

resource "aws_instance" "frontend" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  subnet_id     = element(var.private_subnets, 1)
  key_name      = "tf_user_2_new"
  user_data = templatefile("${path.module}/userdata.sh", {})
  # Attach the Security Group
  vpc_security_group_ids = [var.frontend_lb_sg_id]

  tags = {
    Name = "Frontend"
  }
}

resource "aws_instance" "metabase" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  subnet_id     = element(var.private_subnets, 2)
  key_name      = "tf_user_2_new"
  tags = {
    Name = "Metabase"
  }
}

resource "aws_instance" "bastion" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  subnet_id     = element(var.public_subnets, 0)
  key_name      = "tf_user_2_new"
  tags = {
    Name = "Bastion"
  }
}

# Creating target groups for frontend and backend instances
resource "aws_lb_target_group" "frontend_target_group" {
  name     = "frontend-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group" "backend_target_group" {
  name     = "backend-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# Attaching frontend instances to frontend target group
resource "aws_lb_target_group_attachment" "frontend_attachment" {
  target_group_arn = aws_lb_target_group.frontend_target_group.arn
  target_id        = aws_instance.frontend.id
  port             = 80
}

# Attaching backend instances to backend target group
resource "aws_lb_target_group_attachment" "backend_attachment" {
  target_group_arn = aws_lb_target_group.backend_target_group.arn
  target_id        = aws_instance.backend.id
  port             = 80
}