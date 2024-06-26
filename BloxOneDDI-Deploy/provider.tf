terraform {
  required_providers {
    bloxone = {
      source = "infobloxopen/bloxone"
      version = "1.2.0"
    }
    azurerm = {
    }
  }
}

# Configure the Azure Provider
provider "azurerm" {
  skip_provider_registration = true
  features {}
}

# Configure the BloxOne Provider
provider "bloxone" {
  csp_url = "https://csp.infoblox.com"
  api_key = var.b1_api_key
}