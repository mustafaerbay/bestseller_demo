output "ec2_instance_user_data" {
  value = templatefile("scripts/simple.tftpl",
    {
      "bucket_name" = data.aws_s3_bucket.my_static_website.id
  })
}

output "lb_hostname" {
  value = aws_lb.production.dns_name
}

output "bucket_name" {
  value = data.aws_s3_bucket.my_static_website.id
}