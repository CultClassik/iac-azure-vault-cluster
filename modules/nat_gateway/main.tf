locals {
  resource_base_name = "${var.resource_name_prefix}-%s-${var.environment}-${var.resource_group.location}-%s"
}
resource "azurerm_nat_gateway" "default" {
  location            = var.resource_group.location
  name                = format(local.resource_base_name, "ngw", var.product)
  resource_group_name = var.resource_group.name
  sku_name            = "Standard"
  tags                = var.common_tags
}

resource "azurerm_public_ip" "default" {
  allocation_method   = "Static"
  location            = var.resource_group.location
  name                = format(local.resource_base_name, "pip", "nat")
  resource_group_name = var.resource_group.name
  sku                 = "Standard"
  tags                = var.common_tags
}

resource "azurerm_nat_gateway_public_ip_association" "default" {
  nat_gateway_id       = azurerm_nat_gateway.default.id
  public_ip_address_id = azurerm_public_ip.default.id
}

resource "azurerm_subnet_nat_gateway_association" "default" {
  nat_gateway_id = azurerm_nat_gateway_public_ip_association.default.nat_gateway_id
  subnet_id      = var.subnet_id
}
