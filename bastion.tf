# -----------------------------------------------------------------------------
# Generic Linux system for use as a bastion host to access Vault VMSS nodes.
# -----------------------------------------------------------------------------
# resource "tls_private_key" "bastion" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

resource "azurerm_public_ip" "bastion_pip" {
  name                = replace(local.resource_base_name, "RESTYPE", "vm-pip")
  location            = data.azurerm_resource_group.vault.location
  resource_group_name = data.azurerm_resource_group.vault.name
  allocation_method   = "Dynamic"
}

# Create network interface
resource "azurerm_network_interface" "bastion_nic" {
  name                = replace(local.resource_base_name, "RESTYPE", "vm-nic")
  location            = data.azurerm_resource_group.vault.location
  resource_group_name = data.azurerm_resource_group.vault.name

  ip_configuration {
    name                          = "vault-bastion-ip-config"
    subnet_id                     = data.azurerm_subnet.bastion.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion_pip.id
  }
}

resource "azurerm_network_interface_application_security_group_association" "bastion" {
  network_interface_id          = azurerm_network_interface.bastion_nic.id
  application_security_group_id = module.netsec.vault_application_security_group_ids[0]
}

resource "azurerm_linux_virtual_machine" "bastion" {
  name                  = replace(local.resource_base_name, "RESTYPE", "vm-abs")
  location              = data.azurerm_resource_group.vault.location
  resource_group_name   = data.azurerm_resource_group.vault.name
  network_interface_ids = [azurerm_network_interface.bastion_nic.id]
  size                  = "Standard_B1ls"

  os_disk {
    name                 = "VaultBastionOSDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.vm_image_id
    version   = "latest"
  }

  computer_name                   = "vault-vm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = data.azurerm_key_vault_secret.bastion_public_key.value
  }

  identity {
    type = "SystemAssigned"
  }

}
