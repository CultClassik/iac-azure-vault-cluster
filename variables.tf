variable "environment" {}

variable "az_sub_id" {}

variable "location" {}

# variable "product" {}

# variable "lb_autoscale_max_capacity" {}

# variable "lb_autoscale_min_capacity" {}

# variable "lb_sku_capacity" {}

# variable "lb_private_ip_address" {}

variable "instance_count" {}

variable "instance_type" {}

variable "vm_image_id" {}

variable "vault_version" {}

# variable "network" {}

variable "dns_zone_name" {}

# variable "dns_zone_rg_name" {}

# variable "azure_client_secret" {
#   description = "For the ACME provider"
# }

variable "vnet_rg_name" {}
variable "vnet_name" {}
variable "subnet_name_bastion" {}
variable "subnet_name_vault" {}
variable "subnet_name_vault_agw" {}

variable "key_vault_name" {
  type        = string
  description = "Name of the Keyvault to use. Could be sourced from remote state."
}

variable "vault_identity_id" {
  type        = string
  description = "The resource ID of the MSI used by the Vault cluster nodes. Could be sourced from remote state."
}

variable "vault_identity_client_id" {
  type        = string
  description = "The Client ID of the MSI used by the Vault cluster nodes. Could be sourced from remote state."
}


variable "agw_backend_address_pool_id" {
  type        = string
  description = "The ID of the backend address pool form the AGW to assign the vm scale set instances to"
}
