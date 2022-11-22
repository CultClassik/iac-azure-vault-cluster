data "azurerm_client_config" "current" {}

resource "random_id" "key_vault_suffix" {
  byte_length = floor((24 - (length(var.resource_name_prefix) + 7)) / 2)
}

locals {
  keyvault_name = "${var.resource_name_prefix}${random_id.key_vault_suffix.hex}"
}

# -----------------------------------------------------------------------------
# Create a dedicated Azure keyvault for HashiCorp Vault use
# -----------------------------------------------------------------------------
resource "azurerm_key_vault" "akv" {
  location            = var.resource_group.location
  name                = local.keyvault_name
  resource_group_name = var.resource_group.name
  sku_name            = "standard"
  tags                = var.common_tags
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

# -----------------------------------------------------------------------------
# HashiCorp Vault master key
# -----------------------------------------------------------------------------
resource "azurerm_key_vault_key" "vault" {
  key_size     = 2048
  key_type     = "RSA"
  key_vault_id = azurerm_key_vault.akv.id
  name         = var.user_supplied_key_vault_key_name
  tags         = var.common_tags

  key_opts = [
    "unwrapKey",
    "wrapKey",
  ]
}

# -----------------------------------------------------------------------------
# Vault server TLS certificate to be downloaded by VMSS instances on boot
# -----------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "vault" {
  key_vault_id = azurerm_key_vault_access_policy.owner.key_vault_id
  name         = "${var.resource_name_prefix}-vault-vm-tls"
  tags         = var.common_tags
  value        = var.vault_server_certificate
}

# -----------------------------------------------------------------------------
# SSL Certificate to be used by the Vault cluster nodes
# -----------------------------------------------------------------------------
resource "azurerm_key_vault_certificate" "vault_server" {
  key_vault_id = azurerm_key_vault_access_policy.owner.key_vault_id
  name         = "${var.resource_name_prefix}-vault-cert"
  tags         = var.common_tags

  certificate {
    contents = var.vault_server_certificate
    password = ""
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}

# -----------------------------------------------------------------------------
# SSL Certificate to be used by the Vault cluster load balancer
# -----------------------------------------------------------------------------
resource "azurerm_key_vault_certificate" "lb" {
  key_vault_id = azurerm_key_vault_access_policy.owner.key_vault_id
  name         = "${var.resource_name_prefix}-lb-cert"
  tags         = var.common_tags

  certificate {
    contents = var.vault_lb_certificate
    password = ""
  }

  certificate_policy {
    issuer_parameters {
      name = "Unknown"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }

}
