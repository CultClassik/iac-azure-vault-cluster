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

resource "random_string" "unique_id" {
  length  = 5
  special = false
}

locals {
  vault_env = var.environment == lower("production") ? "prod" : "nonprod"
  resource_name_prefix = "hcv"
  resource_base_name   = "${local.resource_name_prefix}-${random_string.unique_id.result}-RESTYPE-${local.vault_env}-${var.location}"
  shared_san           = format("vault.%s", var.dns_zone_parent_name)

  tags = {
    repo_name   = "iac-azure-vault-cluster",
    environment = var.environment,
    product     = var.product,
    location    = var.location
  }
}

resource "azurerm_resource_group" "vault" {
  name     = replace(local.resource_base_name, "RESTYPE", "rg")
  location = var.location
  tags     = local.tags
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

module "tls" {
  source               = "./modules/tls"
  common_tags          = local.tags
  resource_group       = azurerm_resource_group.vault
  resource_name_prefix = local.resource_name_prefix
  shared_san           = local.shared_san
}

module "vnet" {
  source               = "./modules/vnet"
  common_tags          = local.tags
  resource_group       = azurerm_resource_group.vault
  resource_name_prefix = local.resource_name_prefix
  address_space        = "172.16.15.0/24"
  vault_address_prefix = "172.16.15.0/26"
  lb_address_prefix    = "172.16.15.64/26"
}