resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
}

# resource "aws_s3_bucket_website_configuration" "example" {
#   bucket = aws_s3_bucket.this.id

#   index_document {
#     suffix = "index.html"
#   }

#   error_document {
#     key = "error.html"
#   }
# }