locals {
  region_map = {
    UKS = "UK South"
    UKW = "UK West"
    EUW = "West Europe"
    EUN = "North Europe"
  }

  region_reverse_map = {
    for key, value in local.region_map :
    value => key
  }
}