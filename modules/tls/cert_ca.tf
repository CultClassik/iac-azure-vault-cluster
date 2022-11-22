# -----------------------------------------------------------------------------
# Private CA private key
# -----------------------------------------------------------------------------
resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# -----------------------------------------------------------------------------
# Private CA certificate
# -----------------------------------------------------------------------------
resource "tls_self_signed_cert" "ca" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name = "ca.vault.server.com"
  }

  validity_period_hours = 720 # 30 days

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]

  is_ca_certificate = true

  # PFX generation options https://github.com/hashicorp/terraform-provider-tls/pull/119
  key_algorithm = tls_private_key.ca.algorithm
}
