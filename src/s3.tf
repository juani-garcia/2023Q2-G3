data "aws_iam_policy_document" "bucket_policy_document" {
  statement {
    actions = ["s3:GetObject"]
    resources = [
      module.site_bucket.s3_bucket_arn,
      "${module.site_bucket.s3_bucket_arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [module.cloudfront.web_site_OAI]
    }
  }
}

module "site_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  force_destroy = true
  bucket_prefix =  "tf-guide"

  # Bucket policies
  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket_policy_document.json
  # attach_deny_insecure_transport_policy = true
  # attach_require_latest_tls_policy      = true

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # acl = "private" # "acl" conflicts with "grant" and "owner"

  versioning = {
    status     = true
    mfa_delete = false
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

# resource "aws_s3_object" "data" {
#   for_each = { for file in local.file_with_type : "${file.file_name}.${file.mime}" => file }

#   bucket       = module.site_bucket.s3_bucket_id
#   key          = each.value.file_name
  
#   source       = "${var.static_resources}/${each.value.file_name}"
#   etag         = filemd5("${var.static_resources}/${each.value.file_name}")
#   content_type = each.value.mime
# }

resource "aws_s3_object" "website_data" {
  for_each = fileset("./resources/html", "*")

  bucket = module.site_bucket.s3_bucket_id
  key    = each.value

  source       = "./resources/html/${each.value}"
  etag         = filemd5("./resources/html/${each.value}")
  content_type = "text/html"
}


# Si lo próximo no funciona me mato

# module "site_bucket" {
#   source = "terraform-aws-modules/s3-bucket/aws"
#   force_destroy = true

#   bucket = local.website_bucket_name

#   website = {
#     index_document = "index.html"
#     error_document = "error.html"
#   }

#   attach_policy = true
#   policy        = data.aws_iam_policy_document.allow_access.json

#   attach_deny_insecure_transport_policy = true
#   attach_require_latest_tls_policy      = true
# }

# data "aws_iam_policy_document" "allow_access" {
#   policy_id = "PolicyForCloudFrontPrivateContent"
#   statement {
#     sid       = "AllowCloudFrontServicePrincipal"
#     actions   = ["s3:GetObject"]
#     resources = ["${module.site_bucket.s3_bucket_arn}/*"]

#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }
#   }
# }


## BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB

# module "site_bucket" {
#   force_destroy = true
#   source        = "terraform-aws-modules/s3-bucket/aws"
#   bucket_prefix = "front-"

#   website = {
#     index_document = "index.html"
#     error_document = "error.html"
#   }

#   # attach_policy = true
#   # policy = data.aws_iam_policy_document.allow_access.json

#   # acl = "private"
# }

# data "aws_iam_policy_document" "allow_access" {
#   # policy_id = "PolicyForCloudFrontPrivateContent"
#   statement {
#     sid       = "AllowCloudFrontServicePrincipal"
#     actions   = ["s3:GetObject"]
#     effect   = "Allow"
#     resources = ["${module.site_bucket.s3_bucket_arn}/*"]

#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }
#     # condition {
#     #   test     = "StringLike"
#     #   variable = "aws:Referer"
#     #   values   = [random_password.custom_header.result]
#     # }
#   }
# }

# resource "aws_s3_object" "website_data" {
#   for_each = fileset("./resources/html", "*")

#   bucket = module.site_bucket.s3_bucket_id
#   key    = each.value

#   source       = "./resources/html/${each.value}"
#   etag         = filemd5("./resources/html/${each.value}")
#   content_type = "text/html"
# }

## AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

# module "site_bucket" {

#   force_destroy = true
#   source        = "terraform-aws-modules/s3-bucket/aws"
#   bucket_prefix = "front-"

#   server_side_encryption_configuration = {
#     rule = {
#       apply_server_side_encryption_by_default = {
#         sse_algorithm = "AES256"
#       }
#     }
#   }

#   website = {
#     index_document = "index.html"
#     error_document = "error.html"
#   }

#   logging = {
#     target_bucket = module.logs_bucket.s3_bucket_id
#     target_prefix = "logs/"
#   }
# }

# module "logs_bucket" {
#   source = "terraform-aws-modules/s3-bucket/aws"

#   bucket_prefix = "logs-"
#   force_destroy = true

#   attach_deny_unencrypted_object_uploads = true
#   attach_deny_insecure_transport_policy  = true
#   attach_require_latest_tls_policy       = true
#   server_side_encryption_configuration = {
#     rule = {
#       apply_server_side_encryption_by_default = {
#         sse_algorithm = "AES256"
#       }
#     }
#   }

# }

# module "redirect_bucket" {
#   source = "terraform-aws-modules/s3-bucket/aws"

#   bucket_prefix = "www-"
#   force_destroy = true

#   website = {
#     redirect_all_requests_to = {
#       host_name = module.site_bucket.s3_bucket_bucket_regional_domain_name
#     }
#   }
# }

# resource "aws_s3_object" "website_data" {
#   for_each = fileset("./resources/html", "*")

#   bucket = module.site_bucket.s3_bucket_id
#   key    = each.value

#   source       = "./resources/html/${each.value}"
#   etag         = filemd5("./resources/html/${each.value}")
#   content_type = "text/html"
# }



## Nth try:

# module "site_bucket" {

#   force_destroy = true
#   source = "terraform-aws-modules/s3-bucket/aws"
#   bucket = local.website_bucket_name

#   # server_side_encryption_configuration = {
#   #   rule = {
#   #     apply_server_side_encryption_by_default = {
#   #       sse_algorithm = var.sse_algorithm
#   #     }
#   #   }
#   # }

#   website = {
#     index_document = "index.html"
#     error_document = "error.html"
#   }

#   versioning = {
#     status     = true
#     mfa_delete = false
#   }

#   # logging = {
#   #   target_bucket = module.logs_bucket.s3_bucket_id
#   #   target_prefix = "logs/"
#   # }
# }

# resource "aws_s3_object" "website_data" {
#   for_each = fileset("./resources/html", "*")

#   bucket = module.site_bucket.s3_bucket_id
#   key    = each.value

#   source       = "./resources/html/${each.value}"
#   etag         = filemd5("./resources/html/${each.value}")
#   content_type = "text/html"
# }

# # data "aws_iam_policy_document" "s3_policy" {
# #   version = "2012-10-17"
# #   statement {
# #     actions   = ["s3:GetObject"]
# #     resources = ["${module.site_bucket.s3_bucket_arn}/*"]
# #     principals {
# #       type        = "AWS"
# #       identifiers = module.cloudfront.cloudfront_origin_access_identity_iam_arns
# #     }
# #   }
# # }
# # resource "aws_s3_bucket_policy" "docs" {
# #   bucket = module.site_bucket.s3_bucket_id
# #   policy = data.aws_iam_policy_document.s3_policy.json
# # }

# # module "website_bucket" {
# #   source = "terraform-aws-modules/s3-bucket/aws"

# #   bucket = local.website_bucket_name
# #   acl    = "public-read"

# #   # control_object_ownership = true
# #   # object_ownership         = "ObjectWriter"
# #   block_public_policy      = false

# #   object_lock_enabled = false

# #   # policy = jsonencode({
# #   #   "Version" : "2012-10-17",
# #   #   "Statement" : [
# #   #     {
# #   #       "Sid" : "AllowPublicRead",
# #   #       "Principal" : "*",
# #   #       "Effect" : "Allow",
# #   #       "Action" : "s3:GetObject",
# #   #       "Resource" : ["arn:aws:s3:::${local.website_bucket_name}}/*"],
# #   #     }
# #   #   ]
# #   # })

# #   website = {
# #     index_document = "index.html"
# #     error_document = "404.html"
# #   }
# # }

# # resource "aws_s3_object" "website_data" {
# #   for_each = fileset("./resources/html", "*")

# #   bucket = module.website_bucket.s3_bucket_id
# #   key    = each.value

# #   source       = "./resources/html/${each.value}"
# #   etag         = filemd5("./resources/html/${each.value}")
# #   content_type = "text/html"
# # }