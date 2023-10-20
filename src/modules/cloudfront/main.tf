resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.domain_name}"
}

data "aws_cloudfront_cache_policy" "optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "this" {
  # Si se usa www hay problemas de permisos, la policy dice que solo cloudfront lee pega a site
  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = var.bucket_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  # origin {
  #   domain_name = var.alb_dns_name
  #   origin_id   = var.alb_dns_name

  #   custom_origin_config {
  #     http_port              = 80
  #     https_port             = 443
  #     origin_protocol_policy = "http-only"
  #     origin_ssl_protocols   = ["TLSv1.2"]
  #   }
  # }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "cdn"
  default_root_object = "index.html"
  price_class         = "PriceClass_100"
  # aliases             = var.aliases

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.bucket_id
    cache_policy_id        = data.aws_cloudfront_cache_policy.optimized.id
    viewer_protocol_policy = "redirect-to-https"
    # forwarded_values {
    #   headers      = []
    #   query_string = true
    #   cookies {
    #     forward = "all"
    #   }
    # }
  }

  # ordered_cache_behavior {
  #   path_pattern     = "/api/*"
  #   allowed_methods  = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
  #   cached_methods   = ["GET", "HEAD", "OPTIONS"]
  #   target_origin_id = var.alb_dns_name
  #   cache_policy_id  = data.aws_cloudfront_cache_policy.optimized.id
 

  #   min_ttl                = 0
  #   default_ttl            = 0
  #   max_ttl                = 0
  #   compress               = true
  #   viewer_protocol_policy = "allow-all"
  # }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    # cloudfront_default_certificate = length(var.aliases) == 0

    # acm_certificate_arn      = var.certificate_arn
    # minimum_protocol_version = length(var.aliases) > 0 ? "TLSv1.2_2021" : null
    # ssl_support_method       = length(var.aliases) > 0 ? "sni-only" : null
  }
}


## Si lo próximo no funciona me mato

# resource "aws_cloudfront_distribution" "this" {
#   origin {
#     domain_name = var.domain_name
#     origin_id   = var.origin_id

#     # custom_header {
#     #   name  = "Referer"
#     #   value = random_password.custom_header.result
#     # }
#     custom_origin_config {
#       http_port                = 80
#       https_port               = 443
#       origin_keepalive_timeout = 5
#       origin_protocol_policy   = "http-only"
#       origin_read_timeout      = 30
#       origin_ssl_protocols = [
#         "TLSv1.2",
#       ]
#     }
#   }

#   enabled         = true
#   is_ipv6_enabled = true
#   comment         = "My first CDN"

#   default_cache_behavior {
#     allowed_methods  = ["GET", "HEAD"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = var.origin_id

#     forwarded_values {
#       query_string = false

#       cookies {
#         forward = "none"
#       }
#     }

#     viewer_protocol_policy = "redirect-to-https"
#     min_ttl                = 0
#     default_ttl            = 3600
#     max_ttl                = 86400
#   }

#   price_class = "PriceClass_All"

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }
# }


## "nd try"

# # resource "aws_cloudfront_distribution" "this" {
# #   enabled             = true
# #   default_root_object = var.default_root_object

# #   dynamic "origin" {
# #     for_each = var.origins

# #     content {
# #       domain_name = origin.value.domain_name
# #       origin_id   = origin.value.origin_id
# #       origin_path = ""

# #       dynamic "custom_origin_config" {
# #         for_each = length(lookup(origin.value, "custom_origin_config", "")) == 0 ? [] : [lookup(origin.value, "custom_origin_config", "")]

# #         content {
# #           # origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_OAI.cloudfront_access_identity_path
# #           http_port              = custom_origin_config.value.http_port
# #           https_port             = custom_origin_config.value.https_port
# #           origin_protocol_policy = custom_origin_config.value.origin_protocol_policy
# #           origin_ssl_protocols   = custom_origin_config.value.origin_ssl_protocols
# #         }
# #       }
# #     }
# #   }

# #   dynamic default_cache_behavior {
# #     for_each = var.default_cache_behaviors

# #     content {
# #       allowed_methods        = default_cache_behavior.value.allowed_methods
# #       cached_methods         = default_cache_behavior.value.cached_methods
# #       target_origin_id       = default_cache_behavior.value.target_origin_id
# #       viewer_protocol_policy = default_cache_behavior.value.viewer_protocol_policy

# #       forwarded_values {
# #         query_string = default_cache_behavior.value.query_string
# #         cookies {
# #           forward = default_cache_behavior.value.cookies_forward
# #         }
# #       }
# #     }
# #   }

#   # dynamic "default_cache_behavior" {
#   #   for_each = [var.default_cache_behaviors]

#   #   content {
#   #     target_origin_id       = default_cache_behavior.value["target_origin_id"]
#   #     viewer_protocol_policy = default_cache_behavior.value["viewer_protocol_policy"]

#   #     allowed_methods = default_cache_behavior.value["allowed_methods"]
#   #     cached_methods  = default_cache_behavior.value["cached_methods"]

#   #     forwarded_values {
#   #       query_string = default_cache_behavior.value["query_string"]

#   #       cookies {
#   #         forward = default_cache_behavior.value["cookies_forward"]
#   #       }
#   #     }
#   #   }
#   # }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }
# }

# resource "aws_cloudfront_origin_access_identity" "cloudfront_OAI" {
#   comment = "OAI"
# }

# resource "aws_s3_bucket_policy" "OAI_policy" {
#   bucket = var.bucket_id
#   policy = data.aws_iam_policy_document.frontend_OAI_policy.json
# }


## First try:

# resource "aws_cloudfront_distribution" "this" {
#   enabled             = true
#   default_root_object = var.default_root_object

#   dynamic "origin" {
#     for_each = var.origins

#     content {
#       domain_name = origin.value.domain_name
#       origin_id   = origin.key
#       origin_path = ""

#       dynamic "custom_origin_config" {
#         for_each = length(lookup(origin.value, "custom_origin_config", "")) == 0 ? [] : [lookup(origin.value, "custom_origin_config", "")]

#         content {
#           http_port              = custom_origin_config.value.http_port
#           https_port             = custom_origin_config.value.https_port
#           origin_protocol_policy = custom_origin_config.value.origin_protocol_policy
#           origin_ssl_protocols   = custom_origin_config.value.origin_ssl_protocols
#         }
#       }
#     }

#   }

#   dynamic "default_cache_behavior" {
#     for_each = var.default_cache_behaviors

#     content {
#       allowed_methods        = default_cache_behavior.value.allowed_methods
#       cached_methods         = default_cache_behavior.value.cached_methods
#       target_origin_id       = default_cache_behavior.value.target_origin_id
#       viewer_protocol_policy = default_cache_behavior.value.viewer_protocol_policy

#       forwarded_values {
#         query_string = default_cache_behavior.value.query_string
#         cookies {
#           forward = default_cache_behavior.value.cookies_forward
#         }
#       }
#     }
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }


# }