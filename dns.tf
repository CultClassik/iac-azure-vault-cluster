## delegate dns for the subzone
data "azurerm_dns_zone" "parent" {
  name                = var.dns_zone_parent_name
  resource_group_name = var.dns_zone_parent_rg_name
}

# resource "azurerm_dns_ns_record" "aks_dns" {
#   name                = "aksnp"
#   zone_name           = data.azurerm_dns_zone.parent.name
#   resource_group_name = data.azurerm_dns_zone.parent.resource_group_name
#   ttl                 = 300
#   records             = azurerm_dns_zone.aks_dns.name_servers
#   tags                = local.tags
# }
