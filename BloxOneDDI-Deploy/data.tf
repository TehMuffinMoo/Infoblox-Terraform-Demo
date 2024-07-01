data "bloxone_dhcp_option_codes" "dns_servers" {
  filters = {
    name = "domain-name-servers"
  }
}

data "bloxone_ipam_ip_spaces" "ip_space" {
  filters = {
    name = var.ip_space
  }
}

data "bloxone_dns_views" "dns_view" {
  filters = {
    name = var.dns_view
  }
}

data "bloxone_ipam_address_blocks" "parent_address_block" {
  filters = {
    address = var.parent_address_block
    cidr = var.parent_address_block_cidr
  }
  tag_filters = {
    "Description" = "tf-demo"
  }
}

data "bloxone_ipam_next_available_address_blocks" "next_available_address_blocks" {
  id = data.bloxone_ipam_address_blocks.parent_address_block.results.0.id
  address_block_count = var.address_block_count
  cidr = var.address_block_size
}