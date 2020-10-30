###############################################################################
# Static Values Used Throughout
###############################################################################
locals {
  application         = "api-lambda-dotnet"
  tags                = {
    "salte:account"     = module.data.account_alias
    "salte:application" = local.application
    "salte:department"  = "Research and Development"
    "salte:commit"      = var.CI_COMMIT_SHORT_SHA
    "salte:environment" = terraform.workspace
    "salte:repo"        = var.CI_PROJECT_PATH_SLUG
  }
}

###############################################################################
# Provider Declarations
###############################################################################
provider "archive" {
  version = "~> 1.3"
}

provider "aws" {
  version = "~> 3.6"
  assume_role {
    role_arn = var.assume_role_arn
  }
}

provider "template" {
  version = "~> 2.1"
}

###############################################################################
# Values Pulled from AWS
###############################################################################
module "data" {
  source = "./modules/data"
}

###############################################################################
# Base Naming Convention
###############################################################################
module "name" {
  source = "./modules/resource_name"
  environment   = terraform.workspace
  cloud         = "AWS"
  location      = module.data.current_region
  application   = local.application
}

###############################################################################
# S3 Bucket and Test Object
###############################################################################
resource "aws_s3_bucket" "default" {
  bucket = module.name.kebab_case
  acl    = "private"

  tags = local.tags
}

resource "aws_s3_bucket_object" "default" {
  bucket = aws_s3_bucket.default.bucket
  key    = "hello_world.txt"
  source = "${path.module}/files/data/hello_world.txt"
  etag = filemd5("${path.module}/files/data/hello_world.txt")
  tags = local.tags
}

###############################################################################
# Permissions
###############################################################################
resource "aws_iam_role" "default" {
  name = module.name.uppercase
  assume_role_policy = file("${path.module}/files/iam/assume_role_policy.json")

  tags = local.tags
}

resource "aws_iam_policy" "default" {
  name        = module.name.uppercase
  path        = "/"
  description = "Provides access to CloudWatch logs, XRay tracing, and S3 bucket."
  policy      = templatefile("${path.module}/files/iam/policy.json", { bucket_arn =  aws_s3_bucket.default.arn })
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}

###############################################################################
# Lambda Function
###############################################################################
data "archive_file" "default" {
  type = "zip"
  source_dir = "${path.module}/../src/api_lambda_dotnet/bin/Release/netcoreapp3.1/publish"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "default" {
  environment {
    variables = {
      AppS3Bucket = aws_s3_bucket.default.bucket
    }
  }
  filename         = data.archive_file.default.output_path
  function_name    = module.name.kebab_case
  handler          = "api_lambda_dotnet::api_lambda_dotnet.LambdaEntryPoint::FunctionHandlerAsync"
  role             = aws_iam_role.default.arn
  runtime          = "dotnetcore3.1"
  source_code_hash = data.archive_file.default.output_base64sha256
  tags             = local.tags
  timeout          = 900
  tracing_config {
    mode = "Active"
  }
  vpc_config {
    subnet_ids = module.data.private_subnet_ids
    security_group_ids = [
      module.data.private_vpc_default_security_group_id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.default
  ]
}

###############################################################################
# Setup API Gateway Event Source
###############################################################################
data "template_file" "swagger" {
  template = "${file("${path.module}/files/swagger.yaml")}"

  vars = {
    lambda_arn = aws_lambda_function.default.invoke_arn
  }
}

resource "aws_api_gateway_rest_api" "default" {
  name        = "OAuth 2.0 Secured .NET Core 3.1 Lambda API"
  description = "Reference implementation including: AzureAD OAuth 2.0 Security, .NET Core 3.1, AWS Lambda, AWS API Gateway, Terraform for AWS resource provisioning, and Gitlab for build and deployment orchestration."
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  body = data.template_file.swagger.rendered
}

resource "aws_api_gateway_deployment" "default" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  stage_name  = terraform.workspace
}

resource "aws_lambda_permission" "default" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.default.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.default.execution_arn}/*/*/*"
}
