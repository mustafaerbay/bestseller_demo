# Production Load Balancer
resource "aws_lb" "production" {
  name               = "${var.tag}-${var.environment}-lb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.load-balancer.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]

  tags = {
    Name        = "${var.tag}_${var.environment}_lb"
    Environment = "${var.environment}"
  }
}

# Target group
resource "aws_lb_target_group" "default-target-group" {
  name     = "${var.tag}-${var.environment}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.production-vpc.id

  health_check {
    path                = var.health_check_path
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name        = "${var.tag}_aws_lb_target_group"
    Environment = "${var.environment}"
  }
}

# Listener (redirects traffic from the load balancer to the target group)
resource "aws_lb_listener" "ec2-alb-http-listener" {
  load_balancer_arn = aws_lb.production.id
  port              = "80"
  protocol          = "HTTP"
  depends_on = [
    aws_autoscaling_group.nginx,
    aws_lb_target_group.default-target-group
  ]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default-target-group.arn
  }

  tags = {
    Name        = "${var.tag}_${var.environment}_aws_lb_listener"
    Environment = "${var.environment}"
  }
}
