output "arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = aws_s3_bucket.this.arn
}

output "website_url" {
  description = "url of the bucket"
  value       = aws_s3_bucket_website_configuration.this.website_endpoint
}

output "id" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = aws_s3_bucket.this.id
}