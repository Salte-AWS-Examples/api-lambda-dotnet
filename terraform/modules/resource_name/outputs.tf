output "resource_base_name" {
  value = join("", [local.output, upper(var.suffix)])
}

output "server_base_name" {
  value = var.os == "" ? "" : join("", [local.output, lookup(local.operating_system, var.os, upper(var.os)), lookup(local.purpose, var.purpose, upper(var.purpose)), upper(var.suffix)])
}

