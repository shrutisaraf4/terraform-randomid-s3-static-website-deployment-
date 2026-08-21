resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.project1_bucket.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "style_css" {
  bucket       = aws_s3_bucket.project1_bucket.id
  key          = "style.css"
  source       = "style.css"
  content_type = "text/css"
}
