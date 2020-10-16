# data "aws_caller_identity" "default" {}

data "aws_iam_account_alias" "default" {}


data "aws_region" "default" {}

# data "aws_vpc" "default" {}

# data "aws_subnet_ids" "default" {
#   vpc_id = data.aws_vpc.default.id

#   tags = {
#     "gafg:type" = "private"
#   }
# }

# data "aws_subnet" "default" {
#  for_each = data.aws_subnet_ids.default.ids
#  id       = each.value
# }

# data "aws_security_group" "default" {
#   vpc_id = data.aws_vpc.default.id
#   name   = "default"
# }
