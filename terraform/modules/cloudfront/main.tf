resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.domain_name}"
}

# data "aws_cloudfront_cache_policy" "optimized" {
#   name = "Managed-CachingOptimized"
# }

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  comment             = "cdn"
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  # TODO: Chequear tema aliases y www
  # aliases             = var.aliases

  dynamic origin {
    for_each = var.origins

    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id

      dynamic s3_origin_config {
        for_each = origin.value.s3_origin ? [true] : []

        content {
          origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
        }
      }

      dynamic custom_origin_config {
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
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.bucket_id
    # cache_policy_id        = data.aws_cloudfront_cache_policy.optimized.id # Esto no se puede usar con forwarded rules. Sacarlo?
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      headers      = []
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }

  /*
  # Si se usa www hay problemas de permisos, la policy dice que solo cloudfront lee pega a site
  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = var.bucket_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.bucket_id
    cache_policy_id        = data.aws_cloudfront_cache_policy.optimized.id
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      headers      = []
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }
  */

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}