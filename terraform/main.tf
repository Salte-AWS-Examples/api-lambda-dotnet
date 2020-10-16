###############################################################################
# Static Values Used Throughout
###############################################################################
locals {
  application         = "api-lambda-dotnet"
  tags                = {
    "gafg:account"     = module.data.account_alias
    "gafg:application" = local.application
    "gafg:billing"     = "cloudops"
    "gafg:commit"      = var.CI_COMMIT_SHORT_SHA
    "gafg:data_class"  = "internal"
    "gafg:environment" = terraform.workspace
    "gafg:repo"        = var.CI_PROJECT_PATH_SLUG
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

  application   = local.application
  cloud         = "AWS"
  environment   = terraform.workspace
  location      = module.data.current_region
}

###############################################################################
# S3 Bucket
###############################################################################
resource "aws_s3_bucket" "default" {
  bucket = module.name.resource_base_name
  acl    = "private"

  tags = local.tags
}

resource "aws_s3_bucket_object" "default" {
  bucket = aws_s3_bucket.default.bucket
  key    = "data/hello_world.txt"
  source = "${path.module}/files/data/hello_world.txt"
  etag = filemd5("${path.module}/files/data/hello_world.txt")
  tags = local.tags
}

###############################################################################
# Permissions
###############################################################################
resource "aws_iam_role" "default" {
  name = module.name.resource_base_name
  assume_role_policy = file("${path.module}/files/iam/assume_role_policy.json")

  tags = local.tags
}

resource "aws_iam_policy" "default" {
  name        = module.name.resource_base_name
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
  source_dir = "${path.module}/../src/api_lambda_dotnet/bin/Release/netcoreapp3.1"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "default" {
  filename         = data.archive_file.default.output_path
  function_name    = module.name.resource_base_name
  handler          = "main/index.handler"
  role             = aws_iam_role.default.arn
  runtime          = "dotnetcore3.1"
  source_code_hash = data.archive_file.default.output_base64sha256
  tags             = local.tags
  timeout          = 900

  environment {
    variables = {
      AppS3Bucket = aws_s3_bucket.default.bucket
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.default
  ]
}
