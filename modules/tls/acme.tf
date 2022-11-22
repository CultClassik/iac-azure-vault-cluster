# -----------------------------------------------------------------------------
# Create ACME registration and certificate for the load balancer.
# -----------------------------------------------------------------------------
# provider "acme" {
#   server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
# }

resource "tls_private_key" "acme_reg" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.acme_reg.private_key_pem
  email_address   = "chris.diehl@verituity.com"
}

resource "acme_certificate" "vault_lb" {
  account_key_pem           = tls_private_key.acme_reg.private_key_pem
  common_name               = var.shared_san
  subject_alternative_names = [var.shared_san]
  dns_challenge {
    provider = "azure"
    config = {
      AZURE_RESOURCE_GROUP  = var.dns_zone_rg_name
      AZURE_ZONE_NAME       = var.dns_zone_name
      AZURE_CLIENT_ID       = data.azurerm_client_config.current.client_id
      AZURE_SUBSCRIPTION_ID = data.azurerm_client_config.current.subscription_id
      AZURE_TENANT_ID       = data.azurerm_client_config.current.tenant_id

      AZURE_CLIENT_SECRET = var.azure_client_secret
    }
  }
  min_days_remaining = 30 # default is 30
}

resource "azurerm_key_vault_certificate" "lb" {
  key_vault_id = azurerm_key_vault_access_policy.vault.key_vault_id
  name         = "${var.resource_name_prefix}-lb-cert"
  tags         = var.common_tags

  certificate {
    contents = acme_certificate.vault_lb.certificate_p12
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