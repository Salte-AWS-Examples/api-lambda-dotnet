locals {
  application = {
    gitlab            = "000"
    testing           = "001"
    hadoop            = "002"
    salt              = "003"
    aws-dashboard     = "999"
    azure-authorizer  = "888"
    api-lambda-dotnet = "777"
  }
  cloud = {
    aws = "USC1"
  }
  environment = {
    sandbox     = "S"
    development = "D"
    qa          = "Q"
    production  = "P"
  }
  location = {
    us-east-1 = "E1"
    us-east-2 = "E2"
    us-west-1 = "W1"
    us-west-2 = "W2"
  }
  operating_system = {
    linux   = "L"
    windows = "W"
  }
  purpose = {
    application = "AS"
    database    = "DB"
    web         = "WS"
  }
  output = join("", [local.cloud[lower(var.cloud)], local.location[lower(var.location)], local.application[lower(var.application)], lookup(local.environment, lower(var.environment), upper(var.environment))])
}
