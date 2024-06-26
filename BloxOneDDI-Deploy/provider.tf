terraform {
  required_providers {
    bloxone = {
      source = "infobloxopen/bloxone"
      version = "1.2.0"
    }
  }
}

# Configure the BloxOne Provider
provider "bloxone" {
  csp_url = "https://csp.infoblox.com"
  api_key = "$(B1DDI_API_KEY)"
}