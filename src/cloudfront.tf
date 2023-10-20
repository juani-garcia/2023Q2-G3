module "cloudfront" {
  source = "./modules/cloudfront"

  domain_name        = module.site_bucket.s3_bucket_website_endpoint
  bucket_regional_domain_name = module.site_bucket.s3_bucket_bucket_regional_domain_name
  bucket_id          = module.site_bucket.s3_bucket_id
  aliases            = ["www.${module.site_bucket.s3_bucket_website_endpoint}", module.site_bucket.s3_bucket_website_endpoint]
}


## AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

# module "cloudfront" {
#   source = "./modules/cloudfront"

#   depends_on  = [module.apigw, module.site_bucket ] #, aws_s3_object.website_data] # TODO: Add dependency to s3 bucket
#   bucket_arn  = module.site_bucket.s3_bucket_arn
#   bucket_name = module.site_bucket.s3_bucket_bucket_regional_domain_name
#   bucket_id = module.site_bucket.s3_bucket_id
#   origin_id = local.website_bucket_name
#   domain_name = module.site_bucket.s3_bucket_website_endpoint

#   origins = {
#     s3 = {
#       origin_id              = module.site_bucket.s3_bucket_id
#       domain_name            = module.site_bucket.s3_bucket_website_endpoint
#       http_port              = 80
#       https_port             = 443
#       origin_protocol_policy = "match-viewer"
#       origin_ssl_protocols   = ["TLSv1.2"]
#     },
#     api_gw = {
#       origin_id              = module.apigw["HelloWorld"].id
#       domain_name            = replace(replace(module.apigw["HelloWorld"].api_endpoint, "https://", ""), "/", "")
#       http_port              = 80
#       https_port             = 443
#       origin_protocol_policy = "match-viewer"
#       origin_ssl_protocols   = ["TLSv1.2"]
#     }
#   }

#   default_cache_behaviors = {
#     default = {
#       allowed_methods        = ["GET", "HEAD", "POST"]
#       cached_methods         = ["GET", "HEAD"]
#       target_origin_id       = module.site_bucket.s3_bucket_id
#       viewer_protocol_policy = "allow-all"
#       query_string           = false
#       cookies_forward        = "none"
#     }
#   }
# }