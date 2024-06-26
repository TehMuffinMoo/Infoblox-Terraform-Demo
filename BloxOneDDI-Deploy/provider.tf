# Configure the Azure Provider
provider "azurerm" {
  skip_provider_registration = true
  features {}
}

# Configure the BloxOne Provider
provider "bloxone" {
  csp_url = "https://csp.infoblox.com"
  api_key = "$(B1DDI_API_KEY)"
}