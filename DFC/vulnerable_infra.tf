# 1. CRITICAL: Publicly accessible S3 bucket with ACL set to public-read and no encryption
resource "aws_s3_bucket" "vulnerable_bucket" {
  bucket        = "dfc-demo-highly-insecure-bucket-2026"
  acl           = "public-read" # Critical: Public exposure

  tags = {
    Environment = "Demo"
  }
}

# 2. HIGH: SSH open to the entire internet (0.0.0.0/0)
resource "aws_security_group" "allow_ssh_all" {
  name        = "allow_ssh"
  description = "Insecure security group for demo"

  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # High: Insecure ingress
  }
}

# 3. MEDIUM: EBS volume created without encryption enabled
resource "aws_ebs_volume" "unencrypted_volume" {
  availability_zone = "us-east-1a"
  size              = 40
  encrypted         = false # Medium: Missing encryption at rest
}

# 4. LOW: AWS KMS Key missing rotation policy
resource "aws_kms_key" "no_rotation_key" {
  description             = "KMS key without rotation"
  deletion_window_in_days = 10
  enable_key_rotation     = false # Low: Best practice violation
}