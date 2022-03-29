resource "aws_s3_bucket" "my_static_website" {
  bucket = var.bucketname

  tags = {
    Name        = "${var.tag}"
    Environment = "${var.environment}"
  }
}

resource "aws_s3_bucket_acl" "my_static_website" {
  bucket = aws_s3_bucket.my_static_website.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "my_static_website" {
  bucket = aws_s3_bucket.my_static_website.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "file" {
  for_each = fileset(var.website_root, "**")

  bucket      = aws_s3_bucket.my_static_website.id
  key         = each.key
  source      = "${var.website_root}/${each.key}"
  source_hash = filemd5("${var.website_root}/${each.key}")
  acl         = "public-read"
}