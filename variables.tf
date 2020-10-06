locals {
  tags = {
    Project = "hello-world-api-demo"
  }
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "lambda_function_name" {
  type    = string
  default = "hello-world-lambda-function"
}

variable "lambda_handler" {
  type    = string
  default = "hello-world.lambda_handler"
}

variable "iam_role_lambda_name" {
  type    = string
  default = "demo-basic-execution-role"
}

variable "iam_policy_gateway_name" {
  type    = string
  default = "api-gateway-policy-demo"
}

variable "iam_role_gateway_name" {
  type    = string
  default = "api-gateway-invoke-demo"
}

variable "lambda_function_code" {
  type    = string
  default = "./modules/lambda/hello-world-lambda.zip"
}

variable "iam_basic_exec_policy" {
  type    = string
  default = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

variable "api_gateway_name" {
  type    = string
  default = "hello-world-api-gateway"
}

variable "api_getway_stage_name" {
  type    = string
  default = "$default"
}
