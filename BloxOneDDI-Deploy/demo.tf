## Create Azure Subscription
# resource "azurerm_subscription" "infobloxlab" {
#   subscription_name = var.subscription_name
#   billing_scope_id  = data.azurerm_billing_enrollment_account_scope.infobloxlab.id
# }

## Create Azure Resource Group
resource "azurerm_resource_group" "infobloxlab" {
  name     = "rg-${lower(var.subscription_name)}"
  location = var.region
}

## Create Network Allocation
resource "bloxone_ipam_address_block" "address_block" {
    address = trim(data.bloxone_ipam_next_available_address_blocks.next_available_address_blocks.results.0, "\"")
    cidr = 23
    name = var.subscription_name
    comment = var.subscription_description
    space = data.bloxone_ipam_ip_spaces.ip_space.results.0.id
    tags = {
      Description = "tf-demo"
      Owner = "${var.subscription_description}"
      Region = "${local.region_reverse_map[var.region]}"
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
      Region = "${local.region_reverse_map[var.region]}"
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
      Region = "${local.region_reverse_map[var.region]}"
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
      Region = "${local.region_reverse_map[var.region]}"
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
      Region = "${local.region_reverse_map[var.region]}"
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
    Region = "${local.region_reverse_map[var.region]}"
  }
}

## Create DDNS Update ACL
resource "bloxone_dns_acl" "ddns_acl" {
  name = "${var.subscription_name} DDNS ACL"

  # Other Optional fields
  comment = "${var.subscription_name} ACL to allow DDNS updates"
  tags = {
    Description = "tf-demo"
    Owner       = var.subscription_description
    Region = "${local.region_reverse_map[var.region]}"
  }
  list = [
    {
      access  = "allow"
      element = "ip"
      address = "${bloxone_ipam_address_block.address_block_child.address}/${bloxone_ipam_address_block.address_block_child.cidr}"
    },
  ]
}

## Create DNS Zone
resource "bloxone_dns_auth_zone" "auth_zone" {
  fqdn         = "${lower(var.subscription_name)}.${lower(local.region_reverse_map[var.region])}.az.corp.local."
  primary_type = "cloud"
  view = "${data.bloxone_dns_views.dns_view.results[0].id}"
  # Other optional fields
  comment = "${var.subscription_name} DNS Zone"
  tags = {
    Description = "tf-demo"
    Owner       = var.subscription_description
    Region = "${local.region_reverse_map[var.region]}"
  }
  inheritance_sources = {
    update_acl = {
      action = "override"
    }
  }
  query_acl = [
    {
      access  = "allow"
      element = "any"
    },
  ]
  update_acl = [
    {
      element = "acl"
      acl     = bloxone_dns_acl.ddns_acl.id
    },
    {
      access  = "deny"
      element = "any"
    },
  ]
  transfer_acl = [
    {
      access  = "deny"
      element = "any"
    },
  ]
}


