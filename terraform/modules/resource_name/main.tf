locals {
  environment = {
    development = "D"
    test        = "T"
    production  = "P"
  }
  cloud = {
    AWS = "AWS"
    MAZ = "MAZ"
    ESX = "ESX"
    GCP = "GCP"
    PVE = "PVE"
  }
  location = {
    us-east-1 = "E1"
    us-east-2 = "E2"
    us-west-1 = "W1"
    us-west-2 = "W2"
  }
}
