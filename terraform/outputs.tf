output "lb_hostname" {
  value = aws_lb.production.dns_name
}

output "bucket_name" {
  value = data.aws_s3_bucket.my_static_website.id
}