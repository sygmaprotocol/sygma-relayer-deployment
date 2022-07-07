resource "aws_s3_bucket" "config" {
  bucket = format("%s-%s", var.project_name, lower(var.env))

  tags = {
    Name = format("%s-%s", var.project_name, lower(var.env))
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.config.id
  acl    = "private"
}


resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.config.id
  versioning_configuration {
    status = "Enabled"
  }
}