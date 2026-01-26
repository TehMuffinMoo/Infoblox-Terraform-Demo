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
  
  parent_block_addr = trim(data.bloxone_ipam_next_available_address_blocks.next_available_parent.results[0], "\"")
}