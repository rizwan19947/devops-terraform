# Creating the ALB for frontend
resource "aws_lb" "frontend_alb" {
  name               = "frontend-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [module.security_groups.frontend_lb_sg_id]
  subnets            = module.subnets.private_subnets

  tags = {
    Name = "Frontend ALB"
  }
}

# Creating listeners for frontend and backend ALBs
resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
  }
}