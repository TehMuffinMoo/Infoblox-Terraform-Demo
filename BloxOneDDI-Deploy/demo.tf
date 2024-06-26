resource "bloxone_ipam_ip_space" "ip_space" {
  name = var.ip_space
  comment = var.comment
}

resource "bloxone_dns_view" "dns_view" {
  name = var.dns_view
  comment   = var.comment
  ip_spaces = [bloxone_ipam_ip_space.ip_space.id]
}

resource "bloxone_ipam_address_block" "parent_address_block" {
    address = var.parent_address_block
    cidr = var.parent_address_block_cidr
    name = "Terraform Demo - Parent Address Block"
    space = bloxone_ipam_ip_space.ip_space.id
}

data "bloxone_ipam_next_available_address_blocks" "next_available_address_blocks" {
  id = bloxone_ipam_address_block.parent_address_block.id
  address_block_count = var.address_block_count
  cidr = var.address_block_size
}

resource "bloxone_ipam_address_block" "address_blocks" {
    for_each = data.bloxone_ipam_next_available_address_blocks.next_available_address_blocks
    
    next_available_id = data.bloxone_ipam_next_available_address_blocks.next_available_address_blocks.id
    cidr = 24
    name = var.comment
    comment = var.comment
    space = bloxone_ipam_ip_space.ip_space.id
}