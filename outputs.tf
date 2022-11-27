# output "agw_config" {
#   description = "Map of data required to configure application gateway for Vault cluster"
#   value = {
#     autoscale_max_capacity       = var.lb_autoscale_max_capacity
#     autoscale_min_capacity       = var.lb_autoscale_min_capacity
#     backend_ca_cert              = module.tls.root_ca_pem
#     backend_server_name          = local.shared_san
#     common_tags                  = local.tags
#     health_check_path            = local.health_check_path
#     key_vault_ssl_cert_secret_id = module.keyvault.akv_secret_id_vault_lb_cert
#     private_ip_address           = var.lb_private_ip_address
#     resource_group               = azurerm_resource_group.vault
#     resource_name_prefix         = local.resource_name_prefix
#     subnet_id                    = module.vnet.lb_subnet_id
#     zones                        = [1, 3]
#     # sku_capacity                 = var.lb_sku_capacity
#     identity_ids = [
#       module.iam.lb_identity_id,
#     ]
#   }
# }
