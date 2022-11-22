/**
 * Copyright © 2014-2022 HashiCorp, Inc.
 *
 * This Source Code is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this project, you can obtain one at http://mozilla.org/MPL/2.0/.
 *
 */

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
  description = "Prefix applied to resource names"
  type        = string

  # azurerm_key_vault name must not exceed 24 characters and has this as a prefix
  validation {
    condition     = length(var.resource_name_prefix) < 16 && (replace(var.resource_name_prefix, " ", "") == var.resource_name_prefix)
    error_message = "The resource_name_prefix value must be fewer than 16 characters and may not contain spaces."
  }
}

variable "dns_zone_name" {
  description = "The full DNS zone name to use when creating a ACME certificate"
}

variable "dns_zone_rg_name" {
  description = "THe resource group name which contains the DNS zone from dns_zone_name"
}

variable "acme_azure_client_secret" {
  description = "For the ACME provider"
  type        = string
}

variable "acme_email_address" {
  description = "Email address used for ACME registration (Lets Encrypt)"
  type        = string
}

variable "acme_cert_min_days_remaining" {
  default     = 30
  description = ""
  type        = number
}

variable "vault_cluster_host_name" {
  description = "The host name for the Vault cluster. Will be pre-pended to dns_zone_name."
}