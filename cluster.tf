# -----------------------------------------------------------------------------
# Create user data / custom data for vmss boot configuration.
# -----------------------------------------------------------------------------
module "user_data" {
  source                = "./modules/user_data"
  key_vault_key_name    = local.user_supplied_key_vault_key_name
  key_vault_name        = var.key_vault_name #element(split("/", data.azurerm_key_vault.vault.id), length(split("/", data.azurerm_key_vault.vault.id)) - 1)
  key_vault_secret_id   = data.azurerm_key_vault_secret.akv_secret_id_vault_vm_tls.id
  leader_tls_servername = local.shared_san
  resource_group        = data.azurerm_resource_group.vault
  subscription_id       = data.azurerm_client_config.current.subscription_id
  tenant_id             = data.azurerm_client_config.current.tenant_id
  vault_version         = var.vault_version
  vm_scale_set_name     = local.vm_scale_set_name
  vm_identity_client_id = var.vault_identity_client_id
  # user_supplied_userdata_path = var.user_supplied_userdata_path
}

module "vm" {
  source = "./modules/vm"
  # application_security_group_ids = var.vault_application_security_group_ids
  application_security_group_ids = module.netsec.vault_application_security_group_ids
  common_tags                    = local.tags
  health_check_path              = "/v1/sys/health?activecode=200&standbycode=200&sealedcode=200&uninitcode=200"
  instance_count                 = var.instance_count
  instance_type                  = var.instance_type
  resource_group                 = data.azurerm_resource_group.vault
  resource_name_prefix           = local.resource_name_prefix
  scale_set_name                 = local.vm_scale_set_name
  ssh_public_key                 = data.azurerm_key_vault_secret.vault_public_key.value
  subnet_id                      = data.azurerm_subnet.vault.id
  ultra_ssd_enabled              = false
  user_data                      = module.user_data.vault_userdata_base64_encoded
  # zones                          = var.zones

  ### Since this must be supplied the AGW must be created FIRST
  ### we could get this from remote state
  backend_address_pool_ids = [
    # module.load_balancer.backend_address_pool_id,
    var.agw_backend_address_pool_id,
  ]

  identity_ids = [
    var.vault_identity_id,
  ]

  depends_on = [
    module.nat_gateway,
    module.netsec,
  ]
}
