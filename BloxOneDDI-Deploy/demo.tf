## Create Azure Subscription
resource "azurerm_subscription" "infobloxlab" {
  subscription_name = var.subscription_name
  billing_scope_id  = data.azurerm_billing_enrollment_account_scope.infobloxlab.id
}

## Create Subscription Allocation
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

## Create Child Address Block for VNET
resource "bloxone_ipam_address_block" "address_block_child" {
    address = data.bloxone_ipam_next_available_address_blocks.next_available_address_blocks_child.results.0
    cidr = 24
    name = "${var.subscription_name}-vnet"
    comment = "${var.subscription_description} Virtual Network"
    space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
    tags = {
      Description = "tf-demo"
    }
}

## Create Child Subnet for SNET
resource "bloxone_ipam_subnet" "subnet" {
    address = data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.results.0
    cidr = 27
    name = "${var.subscription_name}-snet"
    comment = "${var.subscription_description} Subnet"
    space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
    tags = {
      Description = "tf-demo"
    }
}