location      = "eastus"
environment   = "nonprod"
dns_zone_name = "dev.verituityplatform.com"
# dns_zone_rg_name = "common"

# lb_autoscale_max_capacity = 3
# lb_autoscale_min_capacity = 1
# lb_sku_capacity = <number>
# lb_private_ip_address = "172.16.15.126" # https://developer.hashicorp.com/terraform/language/functions/cidrhost
# lb_subnet_id # - using output from subnet resource, future use pull from remote state in networking workspace

instance_count = 1
instance_type  = "Standard_D2s_v3"

vault_version = "1.12.1-1"

vnet_rg_name          = "hub-rg-nop-eastus"
vnet_name             = "hub-vnet-hub-nop-eastus"
subnet_name_bastion   = "hub-snet-bastion-nop-eastus"
subnet_name_vault     = "hub-snet-vault-nop-eastus"
subnet_name_vault_agw = "hub-snet-agw-nop-eastus"

# network = {
#   address_space        = ""
#   vault_address_prefix = ""
#   lb_address_prefix    = ""
# }

vm_image_id = "18.04-LTS"

# could get this from remote state, but data source requires azuread provider
key_vault_name = "hcv743b85f99bc509"
# key_vault_rg_name = key vault and vault will live in the same RG so re-use the var rg_name
# rg_name = "hcv-rg-nonprod-eastus"

# vault_identity_id is used by the scale set resource, vault_identity_client_id is required for user data/custom data
# could get these from remote state
vault_identity_id        = "/subscriptions/3810f594-f91b-404a-b6eb-ebf9b9e4f62c/resourceGroups/hcv-rg-nonprod-eastus/providers/Microsoft.ManagedIdentity/userAssignedIdentities/hcv-identity-nonprod-vault"
vault_identity_client_id = "1a7d92eb-da03-4354-b1ce-f37669712f12"

# could get this from remote state
agw_backend_address_pool_id = "/subscriptions/3810f594-f91b-404a-b6eb-ebf9b9e4f62c/resourceGroups/agw-rg-nonprod/providers/Microsoft.Network/applicationGateways/agw-nonprod/backendAddressPools/vault-backend-pool"
