output "lb_hostname" {
  value = aws_lb.production.dns_name
}