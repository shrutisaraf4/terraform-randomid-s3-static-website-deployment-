resource "aws_s3_bucket" "project1_bucket" {
  bucket = "project1-bucket-${random_id.bucket_id.hex}"

  tags = {
    Name        = "Project1Bucket"
    Environment = "Dev"
  }
}

# Disable Block Public Access at bucket level
resource "aws_s3_bucket_public_access_block" "project1_bucket_access" {
  bucket                  = aws_s3_bucket.project1_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
