resource "random_id" "sko_bucket" {
  byte_length = 8
}

resource "aws_s3_bucket" "sko_bucket" {
  bucket = "sysdig-sko-bucket-${random_id.sko_bucket.hex}"
}

resource "aws_s3_bucket_public_access_block" "sko_bucket" {
  bucket = aws_s3_bucket.sko_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
