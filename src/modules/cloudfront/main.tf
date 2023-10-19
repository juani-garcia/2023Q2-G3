resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  default_root_object = "website/index.html"
  
  dynamic origin {
    for_each = var.origins

    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.key
      custom_origin_config {
        http_port              = origin.value.http_port
        https_port             = origin.value.https_port
        origin_protocol_policy = origin.value.origin_protocol_policy
        origin_ssl_protocols   = origin.value.origin_ssl_protocols
      }
    }
    
  }

  dynamic default_cache_behavior {
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