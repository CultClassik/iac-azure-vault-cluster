resource "azurerm_dns_a_record" "vault" {
  name                = "vault"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_rg_name
  ttl                 = 300
  target_resource_id  = module.load_balancer.public_ip_id
}
