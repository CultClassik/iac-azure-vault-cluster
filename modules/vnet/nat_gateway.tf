resource "azurerm_nat_gateway" "vault" {
  location            = var.resource_group.location
  name                = "${var.resource_name_prefix}-vault"
  resource_group_name = var.resource_group.name
  sku_name            = "Standard"
  tags                = var.common_tags
}

resource "azurerm_public_ip" "vault_nat" {
  allocation_method   = "Static"
  location            = var.resource_group.location
  name                = "${var.resource_name_prefix}-vault-nat"
  resource_group_name = var.resource_group.name
  sku                 = "Standard"
  tags                = var.common_tags
}

resource "azurerm_nat_gateway_public_ip_association" "vault" {
  nat_gateway_id       = azurerm_nat_gateway.vault.id
  public_ip_address_id = azurerm_public_ip.vault_nat.id
}

resource "azurerm_subnet_nat_gateway_association" "vault" {
  nat_gateway_id = azurerm_nat_gateway_public_ip_association.vault.nat_gateway_id
  subnet_id      = azurerm_subnet.vault.id
}