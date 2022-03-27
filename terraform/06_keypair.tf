resource "aws_key_pair" "production" {
  key_name   = "${var.tag}_key_pair"
  public_key = file(var.ssh_pubkey_file)

  tags = {
    Name        = "${var.tag}"
    Environment = "${var.environment}"
  }
}