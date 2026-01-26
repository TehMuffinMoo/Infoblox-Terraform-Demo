variable "ip_space" {
  type        = string
  description = "Name of the IP Space to use"
}

variable "dns_view" {
  type        = string
  description = "Name of the DNS View to use"
}

variable "comment" {
  type        = string
  description = "Comment applied to all created objects"
  default     = "Managed by Terraform"
}

variable "b1_api_key" {
  type        = string
  description = "BloxOne API Key"
  sensitive   = true
}

variable "b1_csp_url" {
  type        = string
  description = "Infoblox Portal URL"
}

variable "subscription_name" {
  type        = string
  description = "Azure Subscription Name"
}

variable "subscription_description" {
  type        = string
  description = "Azure Subscription Description"
}

variable "region" {
  type        = string
  description = "Azure Region"

  validation {
    condition     = contains(keys(local.region_map), var.region)
    error_message = "Region must be one of: ${join(", ", keys(local.region_map))}"
  }
}
