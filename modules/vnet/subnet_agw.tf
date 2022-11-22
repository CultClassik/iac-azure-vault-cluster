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

# https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-faq#how-do-i-use-application-gateway-v2-with-only-private-frontend-ip-address
resource "azurerm_network_security_group" "vault_lb" {
  location            = var.resource_group.location
  name                = "${var.resource_name_prefix}-vault-lb"
  resource_group_name = var.resource_group.name
  tags                = var.common_tags
}

resource "azurerm_network_security_rule" "vault_lb_allow_gwm" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "65200-65535"
  direction                   = "Inbound"
  name                        = "Allow_GWM"
  network_security_group_name = azurerm_network_security_group.vault_lb.name
  priority                    = 100
  protocol                    = "*"
  resource_group_name         = var.resource_group.name
  source_address_prefix       = "GatewayManager"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "vault_lb_allow_alb" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Inbound"
  name                        = "Allow_AzureLoadBalancer"
  network_security_group_name = azurerm_network_security_group.vault_lb.name
  priority                    = 110
  protocol                    = "*"
  resource_group_name         = var.resource_group.name
  source_address_prefix       = "AzureLoadBalancer"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "vault_lb_allow_inbound_internet_tcp_8200" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "8200"
  direction                   = "Inbound"
  name                        = "Allow_tcp_8200_inbound_Internet"
  network_security_group_name = azurerm_network_security_group.vault_lb.name
  priority                    = 120
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group.name
  source_address_prefix       = "Internet"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "vault_lb_deny_inbound_internet" {
  access                      = "Deny"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Inbound"
  name                        = "DenyAllInbound_Internet"
  network_security_group_name = azurerm_network_security_group.vault_lb.name
  priority                    = 4096
  protocol                    = "*"
  resource_group_name         = var.resource_group.name
  source_address_prefix       = "Internet"
  source_port_range           = "*"
}

resource "azurerm_subnet_network_security_group_association" "vault_lb" {
  subnet_id                 = azurerm_subnet.vault_lb.id
  network_security_group_id = azurerm_network_security_group.vault_lb.id

  depends_on = [
    azurerm_network_security_rule.vault_lb_allow_gwm,
    azurerm_network_security_rule.vault_lb_allow_alb,
    azurerm_network_security_rule.vault_lb_allow_inbound_internet_tcp_8200,
    azurerm_network_security_rule.vault_lb_deny_inbound_internet,
  ]
}
