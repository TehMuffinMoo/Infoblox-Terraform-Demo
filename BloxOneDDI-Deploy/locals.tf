locals {
  region_map = {
    "UK South" = "UKS"
    "UK West" = "UKW"
    "West Europe" = "EUW"
    "North Europe" = "EUN"
  }

  region_reverse_map = {
    for key, value in local.region_map :
    lower(value) => key
  }

  parent_block_addr = trim(data.bloxone_ipam_next_available_address_blocks.next_available_parent.results[0], "\"")
}