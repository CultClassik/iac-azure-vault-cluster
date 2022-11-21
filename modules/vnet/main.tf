# Hashicorp

resource "azurerm_virtual_network" "vault" {
  location            = var.resource_group.location
  name                = "${var.resource_name_prefix}-vault"
  resource_group_name = var.resource_group.name
  tags                = var.common_tags

  address_space = [
    var.address_space,
  ]
}

resource "azurerm_subnet" "vault_lb" {
  name                 = "${var.resource_name_prefix}-vault-lb"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.vault.name

  address_prefixes = [
    var.lb_address_prefix,
  ]

  service_endpoints = [
    "Microsoft.KeyVault",
  ]
}

resource "azurerm_subnet" "vault" {
  name                 = "${var.resource_name_prefix}-vault"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.vault.name

  address_prefixes = [
    var.vault_address_prefix,
  ]

  service_endpoints = [
    "Microsoft.KeyVault",
  ]
}
