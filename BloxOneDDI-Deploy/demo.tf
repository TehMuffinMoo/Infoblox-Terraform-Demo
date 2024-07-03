## Create Azure Subscription
# resource "azurerm_subscription" "infobloxlab" {
#   subscription_name = var.subscription_name
#   billing_scope_id  = data.azurerm_billing_enrollment_account_scope.infobloxlab.id
# }

## Create Azure Resource Group
resource "azurerm_resource_group" "infobloxlab" {
  name     = "rg-${var.subscription_name}"
  location = "UK South"
}

## Create Network Allocation
resource "b1ddi_address_block" "address_block" {
    address = trim(data.bloxone_ipam_next_available_address_blocks.next_available_address_blocks.results.0, "\"")
    cidr = 22
    name = var.subscription_name
    comment = var.subscription_description
    space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
    tags = {
      Description = "tf-demo"
    }
    lifecycle {
      ignore_changes = [
        address,
      ]
    }
}

## Create Child Address Block for VNET
resource "b1ddi_address_block" "address_block_child" {
    address = trim(data.bloxone_ipam_next_available_address_blocks.next_available_address_blocks_child.results.0, "\"")
    cidr = 24
    name = "${var.subscription_name}-vnet"
    comment = "${var.subscription_description} Virtual Network"
    space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
    tags = {
      Description = "tf-demo"
    }
    lifecycle {
      ignore_changes = [
        address,
      ]
    }
}

## Create Dev Child Subnet for SNET
resource "b1ddi_subnet" "subnet-dev" {
    address = trim(data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.results.0, "\"")
    cidr = 27
    name = "${var.subscription_name}-snet-dev"
    comment = "${var.subscription_description} Dev Subnet"
    space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
    tags = {
      Description = "tf-demo"
    }
    lifecycle {
      ignore_changes = [
        address,
      ]
    }
}

## Create Test Child Subnet for SNET
resource "b1ddi_subnet" "subnet-test" {
    address = trim(data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.results.1, "\"")
    cidr = 27
    name = "${var.subscription_name}-snet-test"
    comment = "${var.subscription_description} Test Subnet"
    space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
    tags = {
      Description = "tf-demo"
    }
    lifecycle {
      ignore_changes = [
        address,
      ]
    }
}

## Create Stage Child Subnet for SNET
resource "b1ddi_subnet" "subnet-stage" {
    address = trim(data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.results.2, "\"")
    cidr = 27
    name = "${var.subscription_name}-snet-stage"
    comment = "${var.subscription_description} Stage Subnet"
    space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
    tags = {
      Description = "tf-demo"
    }
    lifecycle {
      ignore_changes = [
        address,
      ]
    }
}

## Create Virtual Network Security Group
resource "azurerm_network_security_group" "infobloxlab_nsg" {
  name                = "${var.subscription_name}-vnet-nsg"
  location            = azurerm_resource_group.infobloxlab.location
  resource_group_name = azurerm_resource_group.infobloxlab.name
}

## Create Virtual Network / Subnet
resource "azurerm_virtual_network" "example" {
  name                = "${var.subscription_name}-vnet"
  location            = azurerm_resource_group.infobloxlab.location
  resource_group_name = azurerm_resource_group.infobloxlab.name
  address_space       = [data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.results.0]
  dns_servers         = ["1.1.1.1", "1.0.0.1"]

  subnet {
    name           = "${var.subscription_name}-snet-dev"
    address_prefix = "${trim(data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.results.0, "\""}/27"
  }

  subnet {
    name           = "${var.subscription_name}-snet-test"
    address_prefix = "${trim(data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.results.1, "\""}/27"
  }

  subnet {
    name           = "${var.subscription_name}-snet-stage"
    address_prefix = "${trim(data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.results.2, "\""}/27"
  }

  tags = {
    Description = "tf-demo"
  }
}