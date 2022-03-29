resource "aws_launch_configuration" "ec2" {
  name_prefix = "${var.tag}-nginx"
  #   image_id      = "${data.aws_ami.ubuntu.id}"
  #   image_id      = "ami-0f9f8a14a577db49a"
  image_id                    = "ami-034dbce9676b1519e"
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.http-group.id, aws_security_group.ssh-group.id, aws_security_group.outbound-all.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  key_name                    = aws_key_pair.production.key_name
  associate_public_ip_address = true
  user_data                   = file("scripts/simple.sh")
  lifecycle {
    create_before_destroy = true
  }
}

# data "template_file" "init" {
#   template = "${file("scripts/simple.sh.tpl")}"

#   vars = {
#     bucket_link = "${aws_instance.some.private_ip}"
#   }
# }