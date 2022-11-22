/**
 * Copyright © 2014-2022 HashiCorp, Inc.
 *
 * This Source Code is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this project, you can obtain one at http://mozilla.org/MPL/2.0/.
 *
 */

locals {
  vm_scale_set_name                = replace(local.resource_base_name, "RESTYPE", "vmss")
  user_supplied_key_vault_key_name = "hashivault"
  health_check_path                = "/v1/sys/health?activecode=200&standbycode=200&sealedcode=200&uninitcode=200"
}

# module "kms" {
#   source = "./modules/kms"

#   common_tags                      = local.tags
#   key_vault_id                     = module.tls.key_vault_id
#   resource_name_prefix             = local.resource_name_prefix
#   user_supplied_key_vault_key_name = local.user_supplied_key_vault_key_name
#   depends_on = [
#     module.tls
#   ]
# }

module "iam" {
  source = "./modules/iam"

  common_tags          = local.tags
  key_vault_id         = module.tls.key_vault_id
  resource_group       = azurerm_resource_group.vault
  resource_name_prefix = local.resource_name_prefix
  tenant_id            = data.azurerm_client_config.current.tenant_id
}

module "user_data" {
  source = "./modules/user_data"

  key_vault_key_name    = local.user_supplied_key_vault_key_name #module.kms.key_vault_key_name
  key_vault_name        = element(split("/", module.tls.key_vault_id), length(split("/", module.tls.key_vault_id)) - 1)
  key_vault_secret_id   = module.tls.key_vault_vm_tls_secret_id
  leader_tls_servername = local.shared_san
  resource_group        = azurerm_resource_group.vault
  subscription_id       = data.azurerm_client_config.current.subscription_id
  tenant_id             = data.azurerm_client_config.current.tenant_id
  vault_version         = var.vault_version
  vm_scale_set_name     = local.vm_scale_set_name
  vm_identity_client_id = module.iam.vm_identity_client_id
  # user_supplied_userdata_path = var.user_supplied_userdata_path
}

module "load_balancer" {
  source = "./modules/load_balancer"

  autoscale_max_capacity = var.lb_autoscale_max_capacity
  autoscale_min_capacity = var.lb_autoscale_min_capacity
  backend_ca_cert        = module.tls.root_ca_pem
  backend_server_name    = local.shared_san
  common_tags            = local.tags
  health_check_path      = local.health_check_path
  # key_vault_ssl_cert_secret_id = module.tls.key_vault_ssl_cert_secret_id
  key_vault_ssl_cert_secret_id = module.tls.key_vault_lb_cert_secret_id
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
  application_security_group_ids = []
  common_tags                    = local.tags
  health_check_path              = local.health_check_path
  instance_count                 = var.instance_count
  instance_type                  = var.instance_type
  resource_group                 = azurerm_resource_group.vault
  resource_name_prefix           = local.resource_name_prefix
  # user_supplied_source_image_id  = var.vm_image_id
  scale_set_name    = local.vm_scale_set_name
  ssh_public_key    = tls_private_key.ssh.public_key_openssh
  subnet_id         = module.vnet.vault_subnet_id
  ultra_ssd_enabled = false
  user_data         = module.user_data.vault_userdata_base64_encoded
  # zones                          = var.zones

  backend_address_pool_ids = [
    module.load_balancer.backend_address_pool_id,
    # azurerm_lb_backend_address_pool.vault_lb_pool.id
  ]

  identity_ids = [
    module.iam.vm_identity_id,
  ]

  # depends_on = [
  #   # need to make sure we can talk to the internet before building vms
  #   azurerm_lb_outbound_rule.vault
  # ]
}