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

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

data "azurerm_client_config" "current" {}

resource "random_string" "unique_id" {
  length  = 5
  special = false
}

locals {
  vault_env                        = var.environment == lower("production") ? "prod" : "nonprod"
  resource_name_prefix             = "hcv"
  resource_base_name               = "${local.resource_name_prefix}-${random_string.unique_id.result}-RESTYPE-${local.vault_env}-${var.location}"
  shared_san                       = format("vault.%s", var.dns_zone_name)
  vm_scale_set_name                = replace(local.resource_base_name, "RESTYPE", "vmss")
  user_supplied_key_vault_key_name = "hashivault"
  health_check_path                = "/v1/sys/health?activecode=200&standbycode=200&sealedcode=200&uninitcode=200"

  env_short_name_ref = {
    development = "dev",
    staging     = "stg",
    production  = "prod"
  }
  env_short_name = local.env_short_name_ref[var.environment]

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
  source                   = "./modules/tls"
  common_tags              = local.tags
  resource_group           = azurerm_resource_group.vault
  resource_name_prefix     = local.resource_name_prefix
  dns_zone_name            = var.dns_zone_name
  dns_zone_rg_name         = var.dns_zone_rg_name
  acme_azure_client_secret = var.azure_client_secret
  vault_cluster_host_name  = "vault"
  acme_email_address       = "devops@verituity.com"
}

module "keyvault" {
  source                           = "./modules/keyvault"
  common_tags                      = local.tags
  resource_group                   = azurerm_resource_group.vault
  resource_name_prefix             = local.resource_name_prefix
  user_supplied_key_vault_key_name = local.user_supplied_key_vault_key_name
  vault_server_certificate         = module.tls.vault_server_cert_pfx
  vault_lb_certificate             = module.tls.vault_lb_cert_pfx
}

module "vnet" {
  source               = "./modules/vnet"
  common_tags          = local.tags
  resource_group       = azurerm_resource_group.vault
  resource_name_prefix = local.resource_name_prefix
  address_space        = "172.16.15.0/24"
  vault_address_prefix = "172.16.15.0/26"
  lb_address_prefix    = "172.16.15.64/26"
  abs_address_prefix   = "172.16.15.128/26"
}

module "user_data" {
  source                = "./modules/user_data"
  key_vault_key_name    = local.user_supplied_key_vault_key_name
  key_vault_name        = element(split("/", module.keyvault.key_vault_id), length(split("/", module.keyvault.key_vault_id)) - 1)
  key_vault_secret_id   = module.keyvault.akv_secret_id_vault_vm_tls
  leader_tls_servername = local.shared_san
  resource_group        = azurerm_resource_group.vault
  subscription_id       = data.azurerm_client_config.current.subscription_id
  tenant_id             = data.azurerm_client_config.current.tenant_id
  vault_version         = var.vault_version
  vm_scale_set_name     = local.vm_scale_set_name
  vm_identity_client_id = module.iam.vm_identity_client_id
  # user_supplied_userdata_path = var.user_supplied_userdata_path
}

module "iam" {
  source               = "./modules/iam"
  common_tags          = local.tags
  key_vault_id         = module.keyvault.key_vault_id
  resource_group       = azurerm_resource_group.vault
  resource_name_prefix = local.resource_name_prefix
  tenant_id            = data.azurerm_client_config.current.tenant_id
}

module "load_balancer" {
  source                       = "./modules/load_balancer"
  autoscale_max_capacity       = var.lb_autoscale_max_capacity
  autoscale_min_capacity       = var.lb_autoscale_min_capacity
  backend_ca_cert              = module.tls.root_ca_pem
  backend_server_name          = local.shared_san
  common_tags                  = local.tags
  health_check_path            = local.health_check_path
  key_vault_ssl_cert_secret_id = module.keyvault.akv_secret_id_vault_lb_cert
  private_ip_address           = var.lb_private_ip_address
  resource_group               = azurerm_resource_group.vault
  resource_name_prefix         = local.resource_name_prefix
  subnet_id                    = module.vnet.lb_subnet_id
  # sku_capacity                 = var.lb_sku_capacity
  # zones                        = var.zones

  identity_ids = [
    module.iam.lb_identity_id,
  ]
}

module "vm" {
  source = "./modules/vm"
  # application_security_group_ids = var.vault_application_security_group_ids
  application_security_group_ids = module.vnet.vault_application_security_group_ids
  common_tags                    = local.tags
  health_check_path              = local.health_check_path
  instance_count                 = var.instance_count
  instance_type                  = var.instance_type
  resource_group                 = azurerm_resource_group.vault
  resource_name_prefix           = local.resource_name_prefix
  scale_set_name                 = local.vm_scale_set_name
  ssh_public_key                 = tls_private_key.ssh.public_key_openssh
  subnet_id                      = module.vnet.vault_subnet_id
  ultra_ssd_enabled              = false
  user_data                      = module.user_data.vault_userdata_base64_encoded
  # zones                          = var.zones

  backend_address_pool_ids = [
    module.load_balancer.backend_address_pool_id,
  ]

  identity_ids = [
    module.iam.vm_identity_id,
  ]

}
