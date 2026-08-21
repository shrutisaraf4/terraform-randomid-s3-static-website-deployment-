output "bucket_name" {
  value = aws_s3_bucket.project1_bucket.bucket
}

output "bucket_region" {
  value = var.aws_region
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.project1_bucket_website.website_endpoint
}
