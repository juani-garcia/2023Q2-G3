variable "domain_name" {
  description = "target domain name of the S3 bucket"
  type = string
}

variable "bucket_regional_domain_name" {
  description = "target domain name of the S3 bucket"
  type = string
}
variable "bucket_id" {
  description = "target domain name of the S3 bucket"
  type = string
}

variable "aliases" {
  description = "Aliases for the distribution"
  type = set(string)
  default = []
}

variable "origins" {
  description = "A map of origins for this CloudFront distribution"
  type        = map(object({
    origin_id              = string
    domain_name            = string
    http_port              = number
    https_port             = number
    origin_protocol_policy = string
    origin_ssl_protocols   = list(string)
    s3_origin              = bool
  }))
  default = {
    "default" = {
      origin_id              = ""
      domain_name            = ""
      http_port              = 0
      https_port             = 0
      origin_protocol_policy = ""
      origin_ssl_protocols   = []
      s3_origin              = true
    }
  }
}


# Si lo próximo no funciona me mato

# variable "origins" {
#   description = "A map of origins for this CloudFront distribution"
#   type        = map(object({
#     origin_id              = string
#     domain_name            = string
#     http_port              = number
#     https_port             = number
#     origin_protocol_policy = string
#     origin_ssl_protocols   = list(string)
#   }))
# }

# variable "default_cache_behaviors" {
#   description = "The default cache behaviors for this CloudFront distribution"
#   type = map(object({
#     allowed_methods = list(string)
#     cached_methods = list(string)
#     target_origin_id = string
#     viewer_protocol_policy = string
#     query_string = bool
#     cookies_forward = string
#   }))
# }

# # variable "default_cache_behaviors" {
# #   description = "The default cache behavior for this distribution"
# #   type        = any
# #   default     = null
# # }

# # variable "default_cache_behaviors" {
# #   description = "A map of default cache behaviors for this CloudFront distribution"
# #   type        = map(object({
# #     allowed_methods        = list(string)
# #     cached_methods         = list(string)
# #     target_origin_id       = string
# #     viewer_protocol_policy = string
# #     query_string           = bool
# #     cookies_forward        = string
# #   }))
# # }

# variable "bucket_arn" {
#   description = "The ARN of the S3 bucket to use as an origin for this CloudFront distribution"
#   type        = string
# }

# variable "bucket_name" {
#   description = "The name of the S3 bucket to use as an origin for this CloudFront distribution"
#   type        = string
# }

# variable "default_root_object" {
#   description = "The default root object for this CloudFront distribution"
#   type        = string
#   default     = null
# }

# variable "bucket_id" {
#   description = "The ID of the S3 bucket to use as an origin for this CloudFront distribution"
#   type        = string
# }

# variable "origin_id" {
#   description = "The ID of the origin for this CloudFront distribution"
#   type        = string
# }

# variable "domain_name" {
#   description = "The domain name of the origin for this CloudFront distribution"
#   type        = string
# }