resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.domain_name}"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  comment             = "cdn"
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  dynamic "origin" {
    for_each = var.origins

    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id
      origin_path = origin.value.s3_origin ? "" : "/api"

      dynamic "s3_origin_config" {
        for_each = origin.value.s3_origin ? [true] : []

        content {
          origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
        }
      }

      dynamic "custom_origin_config" {
        for_each = origin.value.s3_origin ? [] : [true]

        content {
          http_port              = origin.value.http_port
          https_port             = origin.value.https_port
          origin_protocol_policy = origin.value.origin_protocol_policy
          origin_ssl_protocols   = origin.value.origin_ssl_protocols
        }
      }
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.bucket_id
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}