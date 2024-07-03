## Create Azure Subscription
# resource "azurerm_subscription" "infobloxlab" {
#   subscription_name = var.subscription_name
#   billing_scope_id  = data.azurerm_billing_enrollment_account_scope.infobloxlab.id
# }

# ## Create Azure Resource Group
# resource "azurerm_resource_group" "infobloxlab" {
#   name     = "rg-${var.subscription_name}"
#   location = "UK South"
# }

# ## Create Network Allocation
# resource "bloxone_ipam_address_block" "address_block" {
#     next_available_id = data.bloxone_ipam_next_available_address_blocks.next_available_address_blocks.id
#     #address = data.bloxone_ipam_next_available_address_blocks.next_available_address_blocks.results.0
#     cidr = 22
#     name = var.subscription_name
#     comment = var.subscription_description
#     space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
#     # tags = {
#     #   Description = "tf-demo"
#     # }
#     # inheritance_sources = {
#     #   asm_config = {
#     #     asm_enable_block = {
#     #       action = "inherit"
#     #     }
#     #     asm_growth_block = {
#     #       action = "inherit"
#     #     }
#     #     asm_threshold = {
#     #       action = "inherit"
#     #     }
#     #     forecast_period = {
#     #       action = "inherit"
#     #     }
#     #     history = {
#     #       action = "inherit"
#     #     }
#     #     min_total = {
#     #       action = "inherit"
#     #     }
#     #     min_unused = {
#     #       action = "inherit"
#     #     }
#     #   }
#     #   ddns_client_update = {
#     #     action = "inherit"
#     #   }
#     #   ddns_conflict_resolution_mode = {
#     #     action = "inherit"
#     #   }
#     #   ddns_enabled = {
#     #     action = "inherit"
#     #   }
#     #   ddns_hostname_block = {
#     #     action = "inherit"
#     #   }
#     #   ddns_ttl_percent = {
#     #     action = "inherit"
#     #   }
#     #   ddns_update_block = {
#     #     action = "inherit"
#     #   }
#     #   ddns_update_on_renew = {
#     #     action = "inherit"
#     #   }
#     #   ddns_use_conflict_resolution = {
#     #     action = "inherit"
#     #   }
#     #   dhcp_config = {
#     #     abandoned_reclaim_time = {
#     #       action = "override"
#     #     }
#     #     abandoned_reclaim_time_v6 = {
#     #       action = "override"
#     #     }
#     #     allow_unknown = {
#     #       action = "inherit"
#     #     }
#     #     allow_unknown_v6 = {
#     #       action = "inherit"
#     #     }
#     #     echo_client_id = {
#     #       action = "override"
#     #     }
#     #     filters = {
#     #       action = "inherit"
#     #     }
#     #     filters_v6 = {
#     #       action = "inherit"
#     #     }
#     #     ignore_list = {
#     #       action = "inherit"
#     #     }
#     #     lease_time = {
#     #       action = "inherit"
#     #     }
#     #     lease_time_v6 = {
#     #       action = "inherit"
#     #     }
#     #   }
#     #   dhcp_options = {
#     #     action = "inherit"
#     #   }
#     #   header_option_filename = {
#     #     action = "inherit"
#     #   }
#     #   header_option_server_address = {
#     #     action = "inherit"
#     #   }
#     #   header_option_server_name = {
#     #     action = "inherit"
#     #   }
#     #   hostname_rewrite_block = {
#     #     action = "inherit"
#     #   }
#     # }
# }

# ## Create Child Address Block for VNET
# resource "bloxone_ipam_address_block" "address_block_child" {
#     next_available_id = data.bloxone_ipam_next_available_address_blocks.next_available_address_blocks_child.id
#     #address = data.bloxone_ipam_next_available_address_blocks.next_available_address_blocks_child.results.0
#     cidr = 24
#     name = "${var.subscription_name}-vnet"
#     comment = "${var.subscription_description} Virtual Network"
#     space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
#     tags = {
#       Description = "tf-demo"
#     }
# }

# ## Create Child Subnet for SNET
# resource "bloxone_ipam_subnet" "subnet" {
#     next_available_id = data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.id
#     #address = data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.results.0
#     cidr = 27
#     name = "${var.subscription_name}-snet"
#     comment = "${var.subscription_description} Subnet"
#     space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
#     tags = {
#       Description = "tf-demo"
#     }
# }

# ## Create Virtual Network Security Group
# resource "azurerm_network_security_group" "infobloxlab_nsg" {
#   name                = "${var.subscription_name}-vnet-nsg"
#   location            = azurerm_resource_group.infobloxlab.location
#   resource_group_name = azurerm_resource_group.infobloxlab.name
# }

# ## Create Virtual Network / Subnet
# resource "azurerm_virtual_network" "example" {
#   name                = "${var.subscription_name}-vnet"
#   location            = azurerm_resource_group.infobloxlab.location
#   resource_group_name = azurerm_resource_group.infobloxlab.name
#   address_space       = [data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.results.0]
#   dns_servers         = ["1.1.1.1", "1.0.0.1"]

#   subnet {
#     name           = "${var.subscription_name}-snet"
#     address_prefix = "${data.bloxone_ipam_next_available_subnets.next_available_address_blocks_child_snet.results.0}/24"
#   }

#   tags = {
#     Description = "tf-demo"
#   }
# }

resource "bloxone_ipam_address_block" "example_tags" {
  address = "10.0.0.0"
  cidr    = 8
  space   = data.bloxone_ipam_ip_spaces.ip_space.results.0.id

  # Other optional fields
  name    = "example_address_block_tags"
  comment = "Example address block with tags created by the terraform provider"
  tags = {
    location = "site1"
  }
  asm_config = {
    asm_threshold       = 90
    enable              = "true"
    enable_notification = "true"
    forecast_period     = 10
    growth_factor       = 10
    growth_type         = "percent"
    history             = 30
    min_total           = 2
    min_unused          = 10
    reenable_date       = "2024-01-24T10:10:00+00:00"
  }
  dhcp_config = {
    allow_unknown = true
    ignore_list = [
      {
        type  = "hardware"
        value = "aa:bb:cc:dd:ee:ff"
      },
      {
        type  = "client_text"
        value = "001d.a18b.36d0"
      },
      {
        type  = "client_hex"
        value = "333964392D4769302F31"
      }
    ]
  }
}