terraform {
  required_providers {
    bloxone = {
      source  = "infobloxopen/bloxone"
      version = "1.5.4"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

provider "bloxone" {
  csp_url = var.b1_csp_url
  api_key = var.b1_api_key
}
