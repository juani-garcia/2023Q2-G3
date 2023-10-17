# resource "aws_iam_role" "lambda_role" {
#   name               = "lambda_role"
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy" "lambda_role_policy" {
#   name = "lambda_role_policy"
#   role = aws_iam_role.lambda_role.id

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents"
#       ],
#       "Effect": "Allow",
#       "Resource": "arn:aws:logs:*:*:*"
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
#   role       = aws_iam_role.lambda_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

data "archive_file" "lambda_function" {
  count       = length(var.sources)
  type        = "zip"
  source_dir  = "../${var.sources[count.index]}"
  output_path = "../${var.sources[count.index]}/lambda_function_${count.index}.zip"
}

resource "aws_lambda_function" "lambda_function" {
  count         = length(var.lambda_names)
  filename      = "../${var.sources[count.index]}/lambda_function_${count.index}.zip"
  function_name = var.lambda_names[count.index]
  role          = "arn:aws:iam::633166094506:role/LabRole"
  handler       = "../${var.sources[count.index]}.lambda_handler}"
  # source_code_hash = data.archive_file.lambda_function.output_base64sha256
  runtime = "python3.9"
  # depends_on       = [aws_iam_role_policy_attachment.lambda_role_policy_attachment]
  timeout     = "60"
  memory_size = "128"
  vpc_config {
    subnet_ids         = var.subnets
    security_group_ids = var.sgs # TODO: Add security group module
  }
}
