variable "ip_space" {
  type        = string
  description = "Name of the IP Space to create, and where the demo objects will be created in"
}
variable "dns_view" {
  type        = string
  description = "Name of the DNS View to create, and where the demo objects will be created in"
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
variable "address_block_count" {
  type        = number
  description = "The number of address blocks to create"
}
variable "address_block_size" {
  type        = number
  description = "The cidr size of the address blocks to create"
}
variable "subnet_count" {
  type        = number
  description = "The number of subnets to create in each address block"
}
variable "subnet_size" {
  type        = number
  description = "The cidr size of the subnets to create"
}
variable "b1_api_key" {
  type        = string
  description = "BloxOne API Key"
}