resource "aws_launch_template" "nginx" {
  name_prefix   = "${var.tag}_nginx"
  image_id      = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = aws_key_pair.production.key_name
  vpc_security_group_ids = [
      aws_security_group.http-group.id
   ]
  monitoring {
    enabled = true
  }

  tags = {
    Name        = "${var.tag}_aws_launch_template"
    Environment = "${var.environment}"
  }
}



resource "aws_autoscaling_group" "nginx" {
  name                 = "${var.tag}_auto_scaling_group"
  min_size             = var.autoscale_min
  max_size             = var.autoscale_max
  desired_capacity     = var.autoscale_desired
  health_check_type    = "EC2"
  launch_template {
      id = aws_launch_template.nginx.id
      version = "$Latest"
  }

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"


  vpc_zone_identifier  = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  tag {
      key = "Name"
      value = "${var.tag}_aws_autoscaling_group"
      propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.nginx.id
  lb_target_group_arn   = aws_lb_target_group.default-target-group.arn
}

resource "aws_autoscaling_policy" "web_policy_up" {
  name = "${var.tag}_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 100
  autoscaling_group_name = aws_autoscaling_group.nginx.name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name = "${var.tag}_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.nginx.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.web_policy_up.arn ]
}


resource "aws_autoscaling_policy" "web_policy_down" {
  name = "${var.tag}_policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 100
  autoscaling_group_name = aws_autoscaling_group.nginx.name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
  alarm_name = "${var.tag}_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.nginx.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.web_policy_down.arn ]
}