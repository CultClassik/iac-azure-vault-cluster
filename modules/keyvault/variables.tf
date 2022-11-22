variable "common_tags" {
  default     = {}
  description = "(Optional) Map of common tags for all taggable resources"
  type        = map(string)
}

variable "resource_group" {
  description = "Azure resource group in which resources will be deployed"

  type = object({
    name     = string
    location = string
  })
}

variable "resource_name_prefix" {
  default     = "dev"
  description = "Prefix applied to resource names"
  type        = string

  # azurerm_key_vault name must not exceed 24 characters and has this as a prefix
  validation {
    condition     = length(var.resource_name_prefix) < 16 && (replace(var.resource_name_prefix, " ", "") == var.resource_name_prefix)
    error_message = "The resource_name_prefix value must be fewer than 16 characters and may not contain spaces."
  }
}

variable "user_supplied_key_vault_key_name" {
  default     = null
  description = "(Optional) User-provided Key Vault Key name. Providing this will disable the generation of a Key Vault Key used for Vault auto-unseal"
  type        = string
}

variable "vault_server_certificate" {
  description = "Contents of TLS certificate used by Vault cluster nodes (PFX format)"
}

variable "vault_lb_certificate" {
  description = "Contents of TLS certificate used by Vault cluster load balancer (PFX format)"
}

# variable "shared_san" {
#   # default     = "vault.server.com"
#   description = "This is a shared server name that the certs for all Vault nodes contain. This is the same value you will supply as input to the Vault installation module for the leader_tls_servername variable."
#   type        = string
# }
