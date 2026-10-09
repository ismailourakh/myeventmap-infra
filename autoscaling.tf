########################################
# Auto Scaling Group
########################################

resource "aws_autoscaling_group" "backend" {
  name = "myeventmap-asg"

  min_size         = 1
  desired_capacity = 1
  max_size         = 2

  health_check_type         = "ELB"
  health_check_grace_period = 1200

  vpc_zone_identifier = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  target_group_arns = [
    aws_lb_target_group.backend.arn
  ]

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "myeventmap-backend"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 100
      instance_warmup        = 120
    }
  }
}