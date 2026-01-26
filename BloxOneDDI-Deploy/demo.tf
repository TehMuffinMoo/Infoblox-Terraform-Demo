## Create Azure Subscription
# resource "azurerm_subscription" "infobloxlab" {
#   subscription_name = var.subscription_name
#   billing_scope_id  = data.azurerm_billing_enrollment_account_scope.infobloxlab.id
# }

## Create Azure Resource Group
resource "azurerm_resource_group" "infobloxlab" {
  name     = "rg-${lower(var.subscription_name)}"
  location = "UK South"
}

## Create Network Allocation
resource "bloxone_ipam_address_block" "address_block" {
    address = trim(data.bloxone_ipam_next_available_address_blocks.next_available_address_blocks.results.0, "\"")
    cidr = 22
    name = var.subscription_name
    comment = var.subscription_description
    space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
    tags = {
      Description = "tf-demo"
      Owner = "${var.subscription_description}"
    }
    lifecycle {
      ignore_changes = [
        address,
      ]
    }
}

## Create Child Address Block for VNET
resource "bloxone_ipam_address_block" "address_block_child" {
    address = trim(data.bloxone_ipam_next_available_address_blocks.next_available_address_blocks_child.results.0, "\"")
    cidr = 24
    name = "vnet-${lower(var.subscription_name)}"
    comment = "${var.subscription_description} Virtual Network"
    space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
    tags = {
      Description = "tf-demo"
      Owner = "${var.subscription_description}"
    }
    lifecycle {
      ignore_changes = [
        address,
      ]
    }
}

## Create Dev Child Subnet for SNET
resource "bloxone_ipam_subnet" "subnet-dev" {
    address = trim(data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.results.0, "\"")
    cidr = 27
    name = "snet-${lower(var.subscription_name)}-dev"
    comment = "${var.subscription_description} Dev Subnet"
    space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
    tags = {
      Description = "tf-demo"
      Environment = "Development"
      Owner = "${var.subscription_description}"
    }
    lifecycle {
      ignore_changes = [
        address,
      ]
    }
}

## Create Test Child Subnet for SNET
resource "bloxone_ipam_subnet" "subnet-test" {
    address = trim(data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.results.1, "\"")
    cidr = 27
    name = "snet-${lower(var.subscription_name)}-test"
    comment = "${var.subscription_description} Test Subnet"
    space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
    tags = {
      Description = "tf-demo"
      Environment = "Testing"
      Owner = "${var.subscription_description}"
    }
    lifecycle {
      ignore_changes = [
        address,
      ]
    }
}

## Create Stage Child Subnet for SNET
resource "bloxone_ipam_subnet" "subnet-stage" {
    address = trim(data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.results.2, "\"")
    cidr = 27
    name = "snet-${lower(var.subscription_name)}-stage"
    comment = "${var.subscription_description} Stage Subnet"
    space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
    tags = {
      Description = "tf-demo"
      Environment = "Staging"
      Owner = "${var.subscription_description}"
    }
    lifecycle {
      ignore_changes = [
        address,
      ]
    }
}

## Create Virtual Network Security Group
resource "azurerm_network_security_group" "infobloxlab_nsg" {
  name                = "vnet-nsg-${lower(var.subscription_name)}"
  location            = azurerm_resource_group.infobloxlab.location
  resource_group_name = azurerm_resource_group.infobloxlab.name
}

output "debug_parent_block" {
  value = data.bloxone_ipam_address_blocks.parent_address_block
}

output "debug_child_vnet" {
  value = data.bloxone_ipam_next_available_address_blocks.next_available_address_blocks
}

output "debug_child_subnets" {
  value = data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet
}


## Create Virtual Network / Subnet
resource "azurerm_virtual_network" "infobloxlab_vnet" {
  name                = "vnet-${lower(var.subscription_name)}"
  location            = azurerm_resource_group.infobloxlab.location
  resource_group_name = azurerm_resource_group.infobloxlab.name

  address_space = [
    "${trim(data.bloxone_ipam_next_available_address_blocks.next_available_address_blocks_child.results[0], "\"")}/${data.bloxone_ipam_next_available_address_blocks.next_available_address_blocks_child.cidr}"
  ]

  dns_servers = ["192.168.50.10", "192.168.178.10"]

  subnet {
    name              = "snet-${lower(var.subscription_name)}-dev"
    address_prefixes  = [
      "${trim(data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.results[0], "\"")}/${data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.cidr}"
    ]
  }

  subnet {
    name              = "snet-${lower(var.subscription_name)}-test"
    address_prefixes  = [
            "${trim(data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.results[1], "\"")}/${data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.cidr}"
    ]
  }

  subnet {
    name              = "snet-${lower(var.subscription_name)}-stage"
    address_prefixes  = [
            "${trim(data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.results[2], "\"")}/${data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.cidr}"
    ]
  }

  tags = {
    Description = "tf-demo"
    Owner       = var.subscription_description
  }
}
