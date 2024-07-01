resource "bloxone_ipam_address_block" "address_block" {
    address = data.bloxone_ipam_next_available_address_blocks.next_available_address_blocks.results.0
    cidr = 22
    name = var.subscription_name
    comment = var.subscription_description
    space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
    tags = {
      Description = "tf-demo"
    }
}

resource "bloxone_ipam_address_block" "address_block_child" {
    address = bloxone_ipam_address_block.address_block.id
    cidr = 24
    name = "${var.subscription_name}-vnet"
    comment = "${var.subscription_description} Virtual Network"
    space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
    tags = {
      Description = "tf-demo"
    }
}

resource "bloxone_ipam_subnet" "subnet" {
    address = bloxone_ipam_address_block.address_block_child.id
    cidr = 27
    name = "${var.subscription_name}-snet"
    comment = "${var.subscription_description} Subnet"
    space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
    tags = {
      Description = "tf-demo"
    }
}