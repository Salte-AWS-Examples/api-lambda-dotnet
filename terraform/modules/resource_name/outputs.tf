output "uppercase" {
  value = upper(join("", [lookup(local.environment, var.environment, var.environment), lookup(local.cloud, var.cloud, var.cloud), lookup(local.location, var.location, var.location), replace(replace(var.application, "-", ""), "_", "")]))
}

output kebab_case {
  value  = lower(join("", [lookup(local.environment, var.environment, var.environment), "-", lookup(local.cloud, var.cloud, var.cloud), "-", lookup(local.location, var.location, var.location), "-", var.application]))
}

output snake_case {
  value  = lower(join("", [lookup(local.environment, var.environment, var.environment), "_", lookup(local.cloud, var.cloud, var.cloud), "_", lookup(local.location, var.location, var.location), "_", var.application]))
}



