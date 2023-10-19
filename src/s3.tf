module "website_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = local.website_bucket_name
  acl    = "public-read"

  # control_object_ownership = true
  # object_ownership         = "ObjectWriter"
  block_public_policy      = false

  object_lock_enabled = false

  # policy = jsonencode({
  #   "Version" : "2012-10-17",
  #   "Statement" : [
  #     {
  #       "Sid" : "AllowPublicRead",
  #       "Principal" : "*",
  #       "Effect" : "Allow",
  #       "Action" : "s3:GetObject",
  #       "Resource" : ["arn:aws:s3:::${local.website_bucket_name}}/*"],
  #     }
  #   ]
  # })

  website = {
    index_document = "index.html"
    error_document = "404.html"
  }
}

resource "aws_s3_object" "website_data" {
  for_each = fileset("./resources/html", "*")

  bucket = module.website_bucket.s3_bucket_id
  key    = each.value

  source       = "./resources/html/${each.value}"
  etag         = filemd5("./resources/html/${each.value}")
  content_type = "text/html"
}