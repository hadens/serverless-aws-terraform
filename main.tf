/* Remote backend and state locking commented out to make this Terraform code applicable to any AWS account.
   Assumes that AWS API credentials are configured with environment variables or at ~/.aws/credentials */

# terraform {
#   backend "s3" {
#     bucket         = "my-s3-bucket-name"
#     key            = "key"
#     region         = "us-west-2"
#     dynamodb_table = "ddb-name"
#   }
# }

# Configure the AWS Provider
provider "aws" {
  version = "~> 3.0"
  region  = var.region
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = var.iam_basic_exec_policy
}

resource "aws_iam_role" "iam_for_lambda" {
  name = var.iam_role_lambda_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags               = local.tags
}

resource "aws_iam_role" "iam_for_gateway" {
  name = var.iam_role_gateway_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags               = local.tags
}

resource "aws_iam_role_policy" "iam_policy_for_gateway" {
  name = var.iam_policy_gateway_name
  role = aws_iam_role.iam_for_gateway.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "lambda:InvokeFunction",
            "Resource": "${aws_lambda_function.hello_world.invoke_arn}"
        }
    ]
}
EOF
}


resource "aws_lambda_function" "hello_world" {
  filename      = var.lambda_function_code
  function_name = var.lambda_function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.lambda_handler
  description   = "Basic hello world function that will return a 'hello world' message along with a timestamp."

  # Used to trigger updates
  source_code_hash = filebase64sha256(var.lambda_function_code)

  runtime = "python3.8"

  tags = local.tags
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowMyDemoAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_apigatewayv2_api.demo.execution_arn}/*/*/*"
}


resource "aws_apigatewayv2_api" "demo" {
  name          = var.api_gateway_name
  protocol_type = "HTTP"

  credentials_arn = aws_iam_role.iam_for_gateway.arn
  target          = aws_lambda_function.hello_world.arn

  tags = local.tags
}

resource "aws_apigatewayv2_integration" "demo" {
  api_id           = aws_apigatewayv2_api.demo.id
  integration_type = "AWS_PROXY"

  connection_type        = "INTERNET"
  payload_format_version = "2.0"
  description            = "Integrate Hello World Lambda function"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.hello_world.invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "demo" {
  api_id    = aws_apigatewayv2_api.demo.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.demo.id}"
}
