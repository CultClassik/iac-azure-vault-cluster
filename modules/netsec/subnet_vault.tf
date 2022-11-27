resource "azurerm_application_security_group" "vault" {
  location            = var.resource_group.location
  name                = "${var.resource_name_prefix}-vault"
  resource_group_name = var.resource_group.name
  tags                = var.common_tags
}

resource "azurerm_network_security_group" "vault" {
  location            = var.resource_group.location
  name                = "${var.resource_name_prefix}-vault"
  resource_group_name = var.resource_group.name
  tags                = var.common_tags
}

resource "azurerm_network_security_rule" "vault_internet_access" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Outbound"
  name                        = "${var.resource_name_prefix}-vault-access-to-internet"
  network_security_group_name = azurerm_network_security_group.vault.name
  priority                    = 100
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group.name
  source_address_prefix       = "*"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "vault_internal_api" {
  access                      = "Allow"
  description                 = "Allow Vault nodes to reach other on port 8200 for API"
  destination_port_range      = "8200"
  direction                   = "Inbound"
  name                        = "${var.resource_name_prefix}-vault-internal-api"
  network_security_group_name = azurerm_network_security_group.vault.name
  priority                    = 110
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group.name
  source_port_range           = "*"

  destination_application_security_group_ids = [
    azurerm_application_security_group.vault.id,
  ]

  source_application_security_group_ids = [
    azurerm_application_security_group.vault.id,
  ]
}

resource "azurerm_network_security_rule" "vault_internal_raft" {
  access                      = "Allow"
  description                 = "Allow Vault nodes to communicate on port 8201 for replication traffic, request forwarding, and Raft gossip"
  destination_port_range      = "8201"
  direction                   = "Inbound"
  name                        = "${var.resource_name_prefix}-vault-internal-raft"
  network_security_group_name = azurerm_network_security_group.vault.name
  priority                    = 120
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group.name
  source_port_range           = "*"

  destination_application_security_group_ids = [
    azurerm_application_security_group.vault.id,
  ]

  source_application_security_group_ids = [
    azurerm_application_security_group.vault.id,
  ]
}

resource "azurerm_network_security_rule" "vault_lb_inbound" {
  access                      = "Allow"
  description                 = "Allow load balancer to reach Vault nodes on port 8200"
  destination_port_range      = "8200"
  direction                   = "Inbound"
  name                        = "${var.resource_name_prefix}-vault-lb-inbound"
  network_security_group_name = azurerm_network_security_group.vault.name
  priority                    = 130
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group.name
  source_address_prefix       = var.lb_address_prefix
  source_port_range           = "*"

  destination_application_security_group_ids = [
    azurerm_application_security_group.vault.id,
  ]
}

resource "azurerm_network_security_rule" "vault_other_inbound" {
  access                      = "Deny"
  description                 = "Deny any non-matched traffic"
  destination_port_range      = "8200-8201"
  direction                   = "Inbound"
  name                        = "${var.resource_name_prefix}-vault-other-inbound"
  network_security_group_name = azurerm_network_security_group.vault.name
  priority                    = 200
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group.name
  source_address_prefix       = "*"
  source_port_range           = "*"

  destination_application_security_group_ids = [
    azurerm_application_security_group.vault.id,
  ]
}

resource "azurerm_subnet_network_security_group_association" "vault" {
  subnet_id                 = var.vault_subnet_id
  network_security_group_id = azurerm_network_security_group.vault.id

  depends_on = [
    azurerm_network_security_rule.vault_internet_access,
    azurerm_network_security_rule.vault_internal_api,
    azurerm_network_security_rule.vault_internal_raft,
    azurerm_network_security_rule.vault_lb_inbound,
    azurerm_network_security_rule.vault_other_inbound,
  ]
}
