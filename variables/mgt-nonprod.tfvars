az_sub_id = "" # management

location      = "eastus2"
environment   = "nonprod"
dns_zone_name = "nonprod.diehlabsplatform.com"
# dns_zone_rg_name = "common"

# lb_autoscale_max_capacity = 3
# lb_autoscale_min_capacity = 1
# lb_sku_capacity = <number>
# lb_private_ip_address = "172.16.15.126" # https://developer.hashicorp.com/terraform/language/functions/cidrhost
# lb_subnet_id # - using output from subnet resource, future use pull from remote state in networking workspace

instance_count = 1
instance_type  = "Standard_D2s_v3"

vault_version = "1.12.1-1"

vnet_rg_name          = "mgmt-rg-nop-eastus2"
vnet_name             = "mgmt-vnet-hub-nop-eastus2"
subnet_name_bastion   = "mgmt-snet-bastion-nop-eastus2"
subnet_name_vault     = "mgmt-snet-vault-nop-eastus2"
subnet_name_vault_agw = "mgmt-snet-agw-nop-eastus2"

# network = {
#   address_space        = ""
#   vault_address_prefix = ""
#   lb_address_prefix    = ""
# }

vm_image_id = "18.04-LTS"

# could get this from remote state, but data source requires azuread provider
key_vault_name = "hcv4b3b1090d1c267"
# key_vault_rg_name = key vault and vault will live in the same RG so re-use the var rg_name
# rg_name = "hcv-rg-nonprod-eastus"

# vault_identity_id is used by the scale set resource, vault_identity_client_id is required for user data/custom data
# could get these from remote state
vault_identity_id        = "/subscriptions/a75c42cc-a976-4b30-95c6-aba1c6886cba/resourceGroups/hcv-rg-nonprod-eastus2/providers/Microsoft.ManagedIdentity/userAssignedIdentities/hcv-identity-nonprod-vault"
vault_identity_client_id = "e3442d8b-d247-4c44-ad5a-45a23bda6f00"

# could get this from remote state
agw_backend_address_pool_id = "/subscriptions/a75c42cc-a976-4b30-95c6-aba1c6886cba/resourceGroups/agw-rg-nonprod/providers/Microsoft.Network/applicationGateways/agw-nonprod/backendAddressPools/vault-backend-pool"
