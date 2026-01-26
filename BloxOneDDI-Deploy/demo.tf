## Create Azure Subscription
# resource "azurerm_subscription" "sub" {
#   subscription_name = var.subscription_name
#   billing_scope_id  = data.azurerm_billing_enrollment_account_scope.infobloxlab.id
# }

## Create Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${lower(var.subscription_name)}"
  location = var.region
}

## Create Network Allocation
resource "bloxone_ipam_address_block" "parent" {
  address = local.parent_block_addr
  cidr    = 23
  name    = var.subscription_name
  comment = var.subscription_description
  space   = data.bloxone_ipam_ip_spaces.ip_space.results[0].id

  tags = {
    Description = "tf-demo"
    Owner       = var.subscription_description
    Region      = local.region_reverse_map[lower(local.region_map[var.region])]
  }

  lifecycle {
    ignore_changes = [address]
  }
}

## Create Child Address Block for VNET
data "bloxone_ipam_next_available_address_blocks" "child" {
  id                  = bloxone_ipam_address_block.parent.id
  address_block_count = 1
  cidr                = 24
}

locals {
  child_block_addr = trim(data.bloxone_ipam_next_available_address_blocks.child.results[0], "\"")
}

resource "bloxone_ipam_address_block" "child" {
  address = local.child_block_addr
  cidr    = 24
  name    = "vnet-${lower(var.subscription_name)}"
  comment = "${var.subscription_description} Virtual Network"
  space   = data.bloxone_ipam_ip_spaces.ip_space.results[0].id

  tags = {
    Description = "tf-demo"
    Owner       = var.subscription_description
    Region      = local.region_reverse_map[lower(local.region_map[var.region])]
  }

  lifecycle {
    ignore_changes = [address]
  }
}


## Create Subnets
locals {
  environments = ["dev", "test", "stage"]
}

data "bloxone_ipam_next_available_subnets" "snet" {
  id           = bloxone_ipam_address_block.child.id
  subnet_count = length(local.environments)
  cidr         = 27
}

locals {
  snet_addrs = [
    for a in data.bloxone_ipam_next_available_subnets.snet.results :
    trim(a, "\"")
  ]
}

resource "bloxone_ipam_subnet" "subnets" {
  for_each = toset(local.environments)

  address = local.snet_addrs[index(local.environments, each.key)]
  cidr    = 27
  name    = "snet-${lower(var.subscription_name)}-${each.key}"
  comment = "${var.subscription_description} ${title(each.key)} Subnet"
  space   = data.bloxone_ipam_ip_spaces.ip_space.results[0].id

  tags = {
    Description = "tf-demo"
    Environment = title(each.key)
    Owner       = var.subscription_description
    Region      = local.region_reverse_map[lower(local.region_map[var.region])]
  }

  lifecycle {
    ignore_changes = [address]
  }
}


## Create Virtual Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "vnet-nsg-${lower(var.subscription_name)}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

## Create Virtual Network / Subnet
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${lower(var.subscription_name)}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  address_space = [
    "${bloxone_ipam_address_block.child.address}/${bloxone_ipam_address_block.child.cidr}"
  ]

  dns_servers = ["192.168.50.10", "192.168.178.10"]

  dynamic "subnet" {
    for_each = bloxone_ipam_subnet.subnets

    content {
      name             = subnet.value.name
      address_prefixes = ["${subnet.value.address}/${subnet.value.cidr}"]
    }
  }

  tags = {
    Description = "tf-demo"
    Owner       = var.subscription_description
    Region      = local.region_reverse_map[lower(local.region_map[var.region])]
  }
}

## Create DDNS Update ACL
resource "bloxone_dns_acl" "ddns" {
  name    = "${var.subscription_name} DDNS ACL"
  comment = "${var.subscription_name} ACL to allow DDNS updates"

  tags = {
    Description = "tf-demo"
    Owner       = var.subscription_description
    Region      = local.region_reverse_map[lower(local.region_map[var.region])]
  }

  list = [
    {
      access  = "allow"
      element = "ip"
      address = "${bloxone_ipam_address_block.child.address}/${bloxone_ipam_address_block.child.cidr}"
    }
  ]
}

## Create DNS Zone
resource "bloxone_dns_auth_zone" "zone" {
  fqdn         = "${lower(var.subscription_name)}.${lower(local.region_reverse_map[lower(local.region_map[var.region])])}.az.corp.local."
  primary_type = "cloud"
  view         = data.bloxone_dns_views.dns_view.results[0].id

  comment = "${var.subscription_name} DNS Zone"

  tags = {
    Description = "tf-demo"
    Owner       = var.subscription_description
    Region      = local.region_reverse_map[lower(local.region_map[var.region])]
  }

  inheritance_sources = {
    update_acl = { action = "override" }
  }

  query_acl = [{ access = "allow", element = "any" }]

  update_acl = [
    { element = "acl", acl = bloxone_dns_acl.ddns.id },
    { access = "deny", element = "any" }
  ]

  transfer_acl = [{ access = "deny", element = "any" }]
}