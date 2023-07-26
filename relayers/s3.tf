resource "aws_s3_bucket" "config" {
  bucket = format("%s-%s", var.project_name, lower(var.env))

  tags = {
    Name = format("%s-%s", var.project_name, lower(var.env))
  }
}
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.config.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "config" {
  bucket = aws_s3_bucket.config.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_public_access_block" "config" {
  bucket = aws_s3_bucket.config.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "config" {
  depends_on = [
	aws_s3_bucket_public_access_block.config,
	aws_s3_bucket_ownership_controls.config,
  ]

  bucket = aws_s3_bucket.config.id
  acl    = "public-read"
}

resource "aws_s3_bucket_cors_configuration" "config" {
  bucket = aws_s3_bucket.config.id

  cors_rule {
    allowed_headers = []
    allowed_methods = [
      "GET",
    ]
    allowed_origins = [
      "*",
    ]
    expose_headers  = []    
    max_age_seconds = 300
  }
}