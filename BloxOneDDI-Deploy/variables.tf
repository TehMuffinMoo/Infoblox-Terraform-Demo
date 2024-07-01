variable "ip_space" {
  type        = string
  description = "Name of the IP Space to use, and where the demo objects will be created in"
}
variable "dns_view" {
  type        = string
  description = "Name of the DNS View to use, and where the demo objects will be created in"
}
variable "comment" {
  type        = string
  description = "The comment to apply to all created objects"
}
variable "parent_address_block" {
  type        = string
  description = "The parent address block to create"
}
variable "parent_address_block_cidr" {
  type        = number
  description = "The parent address block cidr size"
}
variable "b1_api_key" {
  type        = string
  description = "BloxOne API Key"
}
variable "subscription_name" {
    type        = string
    description = "Azure Subscription Name"
}
variable "subscription_description" {
    type        = string
    description = "Azure Subscription Description"
}