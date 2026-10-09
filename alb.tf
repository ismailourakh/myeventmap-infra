########################################
# Application Load Balancer
########################################

resource "aws_lb" "backend" {
  name               = "myeventmap-alb"
  load_balancer_type = "application"
  internal           = false

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  enable_deletion_protection = false

  tags = {
    Name = "myeventmap-alb"
  }
}

########################################
# Target Group
########################################

resource "aws_lb_target_group" "backend" {
  name     = "myeventmap-tg"
  port     = 3000
  protocol = "HTTP"

  vpc_id = aws_vpc.main.id

  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  tags = {
    Name = "myeventmap-target-group"
  }
}

########################################
# HTTP Listener
########################################

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.backend.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.backend.arn
  }
}