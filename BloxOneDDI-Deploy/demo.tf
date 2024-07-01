data "bloxone_ipam_next_available_address_blocks" "next_available_address_blocks" {
  id = data.bloxone_ipam_address_blocks.parent_address_block.results.0.id
  address_block_count = var.address_block_count
  cidr = var.address_block_size
}

resource "bloxone_ipam_address_block" "address_blocks" {
    address = data.bloxone_ipam_next_available_address_blocks.next_available_address_blocks.results.0
    cidr = var.subnet_size
    name = var.comment
    comment = var.comment
    space = bloxone_ipam_ip_space.ip_space.id
}