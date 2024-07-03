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
resource "bloxone_ipam_address_block" "address_block" {
    address = data.bloxone_ipam_next_available_address_blocks.next_available_address_blocks.results.0
    cidr = 22
    name = var.subscription_name
    comment = var.subscription_description
    space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
    tags = {
      Description = "tf-demo"
    }
    inheritance_sources = {
      asm_config = {
        asm_enable_block = {
          action = "inherit"
          display_name = "Global DHCP Properties"
        }
        asm_growth_block = {
          action = "inherit"
          display_name = "Global DHCP Properties"
        }
        asm_threshold = {
          action = "inherit"
          display_name = "Global DHCP Properties"
        }
        forecast_period = {
          action = "inherit"
          display_name = "Global DHCP Properties"
        }
        history = {
          action = "inherit"
          display_name = "Global DHCP Properties"
        }
        min_total = {
          action = "inherit"
          display_name = "Global DHCP Properties"
        }
        min_unused = {
          action = "inherit"
          display_name = "Global DHCP Properties"
        }
      }
      ddns_client_update = {
        action = "inherit"
        display_name = "Global DHCP Properties"
      }
      ddns_conflict_resolution_mode = {
        action = "inherit"
        display_name = "Global DHCP Properties"
      }
      ddns_enabled = {
        action = "inherit"
        display_name = "Global DHCP Properties"
      }
      ddns_hostname_block = {
        action = "inherit"
        display_name = "Global DHCP Properties"
      }
      ddns_ttl_percent = {
        action = "inherit"
        display_name = "Global DHCP Properties"
      }
      ddns_update_block = {
        action = "inherit"
        display_name = "Global DHCP Properties"
      }
      ddns_update_on_renew = {
        action = "inherit"
        display_name = "Global DHCP Properties"
      }
      ddns_use_conflict_resolution = {
        action = "inherit"
        display_name = "Global DHCP Properties"
      }
      dhcp_config = {
        abandoned_reclaim_time = {
          action = "override"
          display_name = "Global DHCP Properties"
        }
        abandoned_reclaim_time_v6 = {
          action = "override"
          display_name = "Global DHCP Properties"
        }
        allow_unknown = {
          action = "inherit"
          display_name = "Global DHCP Properties"
        }
        allow_unknown_v6 = {
          action = "inherit"
          display_name = "Global DHCP Properties"
        }
        echo_client_id = {
          action = "override"
          display_name = "Global DHCP Properties"
        }
        filters = {
          action = "inherit"
          display_name = "Global DHCP Properties"
        }
        filters_v6 = {
          action = "inherit"
          display_name = "Global DHCP Properties"
        }
        ignore_list = {
          action = "inherit"
          display_name = "Global DHCP Properties"
        }
        lease_time = {
          action = "inherit"
          display_name = "Global DHCP Properties"
        }
        lease_time_v6 = {
          action = "inherit"
          display_name = "Global DHCP Properties"
        }
      }
      dhcp_options = {
        action = "inherit"
        display_name = "Global DHCP Properties"
      }
      header_option_filename = {
        action = "inherit"
        display_name = "Global DHCP Properties"
      }
      header_option_server_address = {
        action = "inherit"
        display_name = "Global DHCP Properties"
      }
      header_option_server_name = {
        action = "inherit"
        display_name = "Global DHCP Properties"
      }
      hostname_rewrite_block = {
        action = "inherit"
        display_name = "Global DHCP Properties"
      }
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
  dns_servers         = ["1.1.1.1" "1.0.0.1"]

  subnet {
    name           = "${var.subscription_name}-snet"
    address_prefix = "${data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.results.0}/24"
  }

  tags = {
    Description = "tf-demo"
  }
}