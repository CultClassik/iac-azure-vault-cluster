resource "azurerm_network_security_group" "bastion" {
  location            = var.resource_group.location
  name                = "${var.resource_name_prefix}-vault-bastion"
  resource_group_name = var.resource_group.name
  tags                = var.common_tags
}

resource "azurerm_network_security_rule" "bastion_ssh" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "${var.resource_name_prefix}-internet-ssh-to-bastion"
  network_security_group_name = azurerm_network_security_group.bastion.name
  priority                    = 100
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group.name
  source_address_prefix       = "*"
  source_port_range           = "*"
}

resource "azurerm_subnet_network_security_group_association" "bastion" {
  subnet_id                 = var.bastion_subnet_id
  network_security_group_id = azurerm_network_security_group.bastion.id

  depends_on = [
    azurerm_network_security_rule.bastion_ssh,
  ]
}