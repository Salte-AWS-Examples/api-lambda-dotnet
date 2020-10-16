output "account_alias" {
  value = data.aws_iam_account_alias.default.account_alias
}

output "current_region" {
  value = data.aws_region.default.name
}

# output "availability_zones" {
#   value = [for s in data.aws_subnet.default : s.availability_zone]
# }

# output "default_security_group_id" {
#   value = data.aws_security_group.default.id
# }

# output "subnet_cidrs" {
#   value = [for s in data.aws_subnet.default : s.cidr_block]
# }

# output "subnet_ids" {
#   value = [for s in data.aws_subnet.default : s.id]
# }

# output "user_id" {
#   value = data.aws_caller_identity.default.user_id
# }


# output "vpc_cidr_block" {
#   value = data.aws_vpc.default.cidr_block
# }

# output "vpc_id" {
#   value = data.aws_vpc.default.id
# }
