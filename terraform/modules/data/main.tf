data "aws_caller_identity" "default" {}

data "aws_iam_account_alias" "default" {}


data "aws_region" "default" {}

data "aws_vpc" "private" {
  tags = {
    "Name" = "salte-private"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.private.id

  tags = {
    terraform = true
  }
}

data "aws_subnet" "private" {
 for_each = data.aws_subnet_ids.private.ids
 id       = each.value
}

data "aws_security_group" "private" {
  vpc_id = data.aws_vpc.private.id
  name   = "default"
}
