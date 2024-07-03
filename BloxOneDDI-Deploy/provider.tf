terraform {
  required_providers {
    # bloxone = {
    #   source = "infobloxopen/bloxone"
    #   version = "1.2.0"
    # }
    bloxone = {
      source = "infobloxopen/b1ddi"
      version = "0.1.5"
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

#provider "azurerm" {
#  alias = "specific"
#  subscription_id = azurerm_subscription.infobloxlab.id
#  features {}
#  skip_provider_registration = true
#}

# Configure the BloxOne Provider
provider "bloxone" {
  csp_url = "https://csp.infoblox.com"
  api_key = var.b1_api_key
}

terraform {
   backend "azurerm" {}
}