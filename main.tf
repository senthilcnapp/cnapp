provider "aws" {
  region = "us-east-1"
}

# Misconfiguration: Security group allows unrestricted SSH access
resource "aws_security_group" "vulnerable_sg" {
  name        = "vulnerable_sg"
  description = "Allow SSH from everywhere"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

# Misconfiguration: S3 bucket without encryption and publicly accessible
resource "aws_s3_bucket" "vulnerable_bucket" {
  bucket        = "defender-cloud-demo-bucket-unsecure"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "public_allow" {
  bucket = aws_s3_bucket.vulnerable_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
