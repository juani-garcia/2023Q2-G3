module "cloudfront" {
  source = "./modules/cloudfront"

  domain_name        = module.dineout_website_bucket.s3_bucket_website_endpoint
  bucket_regional_domain_name = module.dineout_website_bucket.s3_bucket_bucket_regional_domain_name
  bucket_id          = module.dineout_website_bucket.s3_bucket_id
  aliases            = ["www.${module.dineout_website_bucket.s3_bucket_website_endpoint}", module.dineout_website_bucket.s3_bucket_website_endpoint]

  origins = {
    "s3" = {
      origin_id              = "${module.dineout_website_bucket.s3_bucket_id}"
      domain_name            = "${module.dineout_website_bucket.s3_bucket_bucket_regional_domain_name}"
      http_port              = 0
      https_port             = 0
      origin_protocol_policy = ""
      origin_ssl_protocols   = []
      s3_origin              = true
    },
    "apigw" = {
      origin_id              = module.apigw.id
      domain_name            = replace(replace(module.apigw.endpoint_url, "https://", ""), "/", "")
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
      s3_origin              = false
    }
  }
}