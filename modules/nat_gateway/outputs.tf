output "nat_gateway_id" {
  value = azurerm_nat_gateway.default.id
}

output "azurerm_public_ip" {
  value = azurerm_public_ip.default.ip_address
}
