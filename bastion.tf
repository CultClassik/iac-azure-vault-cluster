# this isn't a good way to do this but ok for testing

# Create public IPs
resource "azurerm_public_ip" "bastion_pip" {
  name                = replace(local.resource_base_name, "RESTYPE", "vm-pip")
  location            = azurerm_resource_group.vault.location
  resource_group_name = azurerm_resource_group.vault.name
  allocation_method   = "Dynamic"
}

# Create network interface
resource "azurerm_network_interface" "bastion_nic" {
  name                = replace(local.resource_base_name, "RESTYPE", "vm-nic")
  location            = azurerm_resource_group.vault.location
  resource_group_name = azurerm_resource_group.vault.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = module.vnet.abs_subnet_id # module.vnet.vault_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "bastion" {
  name                  = replace(local.resource_base_name, "RESTYPE", "vm-abs")
  location              = azurerm_resource_group.vault.location
  resource_group_name   = azurerm_resource_group.vault.name
  network_interface_ids = [azurerm_network_interface.bastion_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "vault-vm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.ssh.public_key_openssh
  }

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_key_vault_secret" "bastion_ssh_private_key" {
  key_vault_id = module.tls.key_vault_id
  name         = "${local.resource_name_prefix}-bastion-ssh-private-key"
  tags         = local.tags
  value        = tls_private_key.ssh.private_key_openssh
}

resource "local_file" "sshkey" {
  content         = tls_private_key.ssh.private_key_openssh
  filename        = "secrets/key.rsa"
  file_permission = "0600"
}

resource "local_file" "userdata" {
  content         = base64decode(module.user_data.vault_userdata_base64_encoded)
  filename        = "secrets/custom_data.sh"
  file_permission = "0600"
}