data "bloxone_dhcp_option_codes" "dns_servers" {
  filters = {
    name = "domain-name-servers"
  }
}