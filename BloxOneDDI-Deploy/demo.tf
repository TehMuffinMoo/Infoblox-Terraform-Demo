resource "bloxone_ipam_ip_space" "ip_space" {
  name = var.ip_space
  comment = var.comment
  lifecycle {
    ignore_changes = all
  }
}

resource "bloxone_dns_view" "dns_view" {
  name = var.dns_view
  comment   = var.comment
  ip_spaces = [bloxone_ipam_ip_space.ip_space.id]
}

# resource "bloxone_ipam_address_block" "parent_address_block" {
#   address = var.parent_address_block
#   cidr = var.parent_address_block_cidr
#   name = "Parent Address Block"
#   comment   = var.comment
#   space = bloxone_ipam_ip_space.ip_space.id
#   dhcp_options = [
#     {
#     option_code  = data.bloxone_dhcp_option_codes.dns_servers.results.0.id
#     option_value = "1.1.1.1"
#     type         = "option"
#     }
#   ]
# }

data "bloxone_ipam_address_blocks" "parent_address_block" {
  filters = {
    name = "Parent Address Block"
  }
}

data "bloxone_ipam_next_available_address_blocks" "next_available_address_blocks" {
  id = data.bloxone_ipam_address_blocks.parent_address_block.results.0.id
  address_block_count = var.address_block_count
  cidr = var.address_block_size
}

# resource "bloxone_ipam_address_block" "address_blocks" {
#     for_each = data.bloxone_ipam_next_available_address_blocks.next_available_address_blocks.results
    
#     next_available_id = each.id
#     cidr = 24
#     name = var.comment
#     comment = var.comment
#     space = bloxone_ipam_ip_space.ip_space.id
# }