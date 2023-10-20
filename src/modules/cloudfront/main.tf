resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  default_root_object = "website/index.html"

  dynamic "origin" {
    for_each = var.origins

    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.key

      dynamic "custom_origin_config" {
        for_each = length(lookup(origin.value, "custom_origin_config", "")) == 0 ? [] : [lookup(origin.value, "custom_origin_config", "")]

        content {
          http_port              = custom_origin_config.value.http_port
          https_port             = custom_origin_config.value.https_port
          origin_protocol_policy = custom_origin_config.value.origin_protocol_policy
          origin_ssl_protocols   = custom_origin_config.value.origin_ssl_protocols
        }
      }
    }

  }

  dynamic "default_cache_behavior" {
    for_each = var.default_cache_behaviors

    content {
      allowed_methods        = default_cache_behavior.value.allowed_methods
      cached_methods         = default_cache_behavior.value.cached_methods
      target_origin_id       = default_cache_behavior.value.target_origin_id
      viewer_protocol_policy = default_cache_behavior.value.viewer_protocol_policy

      forwarded_values {
        query_string = default_cache_behavior.value.query_string
        cookies {
          forward = default_cache_behavior.value.cookies_forward
        }
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

# resource "aws_cloudfront_origin_access_identity" "cloudfront_OAI" {
#   comment = "OAI"
# }

# resource "aws_s3_bucket_policy" "OAI_policy" {
#   # for_each = var.origins
#   bucket = "s3"
#   policy = data.aws_iam_policy_document.frontend_OAI_policy.json
# }