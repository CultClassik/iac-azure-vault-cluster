variable "common_tags" {
  description = "(Optional) Map of common tags for all taggable resources"
  type        = map(string)
}

variable "resource_group" {
  description = "Azure resource group in which resources will be deployed"

  type = object({
    location = string
    name     = string
  })
}

variable "resource_name_prefix" {
  description = "Prefix for resource names (e.g. \"prod\")"
  type        = string
}
variable "vault_subnet_id" {}
variable "agw_subnet_id" {}
variable "bastion_subnet_id" {}
variable "environment" {}
variable "lb_address_prefix" {}
