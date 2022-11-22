resource "azurerm_dns_a_record" "vault" {
  name                = "vault"
  zone_name           = "dev.verituityplatform.com" # data.azurerm_dns_zone.vty.name
  resource_group_name = "common"                    # azurerm_resource_group.vault.name
  ttl                 = 300
  target_resource_id  = module.load_balancer.public_ip_id
}