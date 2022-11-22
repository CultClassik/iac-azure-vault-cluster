# -----------------------------------------------------------------------------
# ACME Registration Private key
# -----------------------------------------------------------------------------
resource "tls_private_key" "acme_reg" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# -----------------------------------------------------------------------------
# ACME Registration
# -----------------------------------------------------------------------------
resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.acme_reg.private_key_pem
  email_address   = var.acme_email_address
}

resource "acme_certificate" "lb" {
  account_key_pem           = tls_private_key.acme_reg.private_key_pem
  common_name               = local.shared_san
  subject_alternative_names = [local.shared_san]
  dns_challenge {
    provider = "azure"
    config = {
      AZURE_RESOURCE_GROUP  = var.dns_zone_rg_name
      AZURE_ZONE_NAME       = var.dns_zone_name
      AZURE_CLIENT_ID       = data.azurerm_client_config.current.client_id
      AZURE_SUBSCRIPTION_ID = data.azurerm_client_config.current.subscription_id
      AZURE_TENANT_ID       = data.azurerm_client_config.current.tenant_id
      AZURE_CLIENT_SECRET   = var.acme_azure_client_secret
    }
  }
  min_days_remaining = var.acme_cert_min_days_remaining
}
