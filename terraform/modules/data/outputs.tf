output "account_alias" {
  value = data.aws_iam_account_alias.default.account_alias
}

output "current_region" {
  value = data.aws_region.default.name
}

output "private_availability_zones" {
  value = [for s in data.aws_subnet.private : s.availability_zone]
}

output "private_subnet_cidrs" {
  value = [for s in data.aws_subnet.private : s.cidr_block]
}

output "private_subnet_ids" {
  value = [for s in data.aws_subnet.private : s.id]
}

output "private_vpc_cidr_block" {
  value = data.aws_vpc.private.cidr_block
}

output "private_vpc_default_security_group_id" {
  value = data.aws_security_group.private.id
}

output "private_vpc_id" {
  value = data.aws_vpc.private.id
}

output "user_id" {
  value = data.aws_caller_identity.default.user_id
}
