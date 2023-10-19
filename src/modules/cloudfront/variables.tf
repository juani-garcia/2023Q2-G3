variable "origins" {
  description = "The origins for this CloudFront distribution"
  type = map(object({
    domain_name = string
    http_port = number
    https_port = number
    origin_protocol_policy = string
    origin_ssl_protocols = list(string)
  }))
}

variable "default_cache_behaviors" {
  description = "The default cache behaviors for this CloudFront distribution"
  type = map(object({
    allowed_methods = list(string)
    cached_methods = list(string)
    target_origin_id = string
    viewer_protocol_policy = string
    query_string = bool
    cookies_forward = string
  }))
}