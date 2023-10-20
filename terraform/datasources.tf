data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

data "aws_caller_identity" "current" {

}

data "aws_region" "current" {

}

data "aws_iam_policy_document" "bucket_policy_document" {
  statement {
    actions = ["s3:GetObject"]
    resources = [
      module.dineout_website_bucket.s3_bucket_arn,
      "${module.dineout_website_bucket.s3_bucket_arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [module.cloudfront.web_site_OAI]
    }
  }
}