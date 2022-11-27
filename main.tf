provider "azurerm" {
  features {
    virtual_machine_scale_set {
      # This can be enabled to sequentially replace instances when
      # application configuration updates (e.g. changed user_data)
      # are made
      roll_instances_when_required = false
    }
  }
  subscription_id = var.arm_subscription_id
}

data "azurerm_client_config" "current" {}

locals {
  resource_name_prefix             = "hcv"
  resource_base_name               = "${local.resource_name_prefix}-RESTYPE-${var.environment}-${var.location}"
  shared_san                       = format("vault.%s", var.dns_zone_name)
  vm_scale_set_name                = replace(local.resource_base_name, "RESTYPE", "vmss")
  user_supplied_key_vault_key_name = "hashivault"
  # health_check_path                = "/v1/sys/health?activecode=200&standbycode=200&sealedcode=200&uninitcode=200"
  tags = {
    repo_name   = "verituity/devops/azure-infrastructure/iac-azure-vault-cluster",
    environment = var.environment,
    product     = "vault",
    location    = data.azurerm_resource_group.vault.location
  }
}

# -----------------------------------------------------------------------------
# Data sources - resource group and network
# -----------------------------------------------------------------------------
data "azurerm_resource_group" "vault" {
  name = "${local.resource_name_prefix}-rg-${var.environment}-${var.location}"
}

data "azurerm_subnet" "bastion" {
  name                 = var.subnet_name_bastion
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg_name
}

data "azurerm_subnet" "vault" {
  name                 = var.subnet_name_vault
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg_name
}

data "azurerm_subnet" "agw" {
  name                 = var.subnet_name_vault_agw
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg_name
}

# -----------------------------------------------------------------------------
# Data sources - key vault and secrets
# -----------------------------------------------------------------------------
data "azurerm_key_vault" "vault" {
  name                = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.vault.name
}

data "azurerm_key_vault_secret" "akv_secret_id_vault_vm_tls" {
  name         = "${local.resource_name_prefix}-vault-vm-tls"
  key_vault_id = data.azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "vault_public_key" {
  name         = "${local.resource_name_prefix}-vault-ssh-public-key-nodes"
  key_vault_id = data.azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "vault_private_key" {
  name         = "${local.resource_name_prefix}-vault-ssh-key-nodes"
  key_vault_id = data.azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "bastion_public_key" {
  name         = "${local.resource_name_prefix}-vault-ssh-public-key-bastion"
  key_vault_id = data.azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "bastion_private_key" {
  name         = "${local.resource_name_prefix}-vault-ssh-key-bastion"
  key_vault_id = data.azurerm_key_vault.vault.id
}

module "nat_gateway" {
  source               = "./modules/nat_gateway"
  resource_group       = data.azurerm_resource_group.vault
  common_tags          = local.tags
  product              = "vault"
  resource_name_prefix = "hcv"
  environment          = var.environment
  subnet_id            = data.azurerm_subnet.vault.id
}

module "netsec" {
  source               = "./modules/netsec"
  resource_group       = data.azurerm_resource_group.vault
  common_tags          = local.tags
  resource_name_prefix = "hcv"
  environment          = var.environment
  vault_subnet_id      = data.azurerm_subnet.vault.id
  agw_subnet_id        = data.azurerm_subnet.agw.id
  bastion_subnet_id    = data.azurerm_subnet.bastion.id
  lb_address_prefix    = data.azurerm_subnet.agw.address_prefixes[0]
}