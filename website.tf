resource "aws_s3_bucket_website_configuration" "project1_bucket_website" {
  bucket = aws_s3_bucket.project1_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
