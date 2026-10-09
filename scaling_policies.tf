# Scale UP when CPU > 70%
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "myeventmap-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.backend.name
  cooldown               = 300
}

# CloudWatch Alarm to trigger scale-up
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "myeventmap-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
}

# Scale DOWN when CPU < 30%
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "myeventmap-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.backend.name
  cooldown               = 300
}