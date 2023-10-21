module "dineout_website_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  force_destroy = true
  bucket_prefix = "front"

  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket_policy_document.json

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    status = false
  }

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

}

resource "aws_s3_object" "website_data" {
  for_each = local.htmls

  bucket = module.dineout_website_bucket.s3_bucket_id
  key    = each.key

  content = each.value.content
  # source       = "./resources/html/${each.value}"
  etag         = filemd5("${each.value.path}")
  content_type = each.value.content_type
}