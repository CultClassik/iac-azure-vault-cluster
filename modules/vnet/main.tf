/**
 * Copyright © 2014-2022 HashiCorp, Inc.
 *
 * This Source Code is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this project, you can obtain one at http://mozilla.org/MPL/2.0/.
 *
 */

resource "azurerm_virtual_network" "vault" {
  location            = var.resource_group.location
  name                = "${var.resource_name_prefix}-vault"
  resource_group_name = var.resource_group.name
  tags                = var.common_tags

  address_space = [
    var.address_space,
  ]
}



resource "azurerm_subnet" "vault_abs" {
  count = var.abs_address_prefix == null ? 0 : 1

  address_prefixes     = [var.abs_address_prefix] # at least /27 or larger
name                 = "${var.resource_name_prefix}-bastion"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.vault.name
}
