resource "aws_launch_configuration" "ec2" {
  name_prefix                 = "${var.tag}-nginx"
  image_id                    = var.instance_ami
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.http-group.id, aws_security_group.ssh-group.id, aws_security_group.outbound-all.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  key_name                    = aws_key_pair.production.key_name
  associate_public_ip_address = true
  user_data = templatefile("scripts/simple.tftpl",
    {
      "bucket_name" = data.aws_s3_bucket.my_static_website.id
  })
  lifecycle {
    create_before_destroy = true
  }
}

