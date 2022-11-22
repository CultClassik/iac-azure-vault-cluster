output "root_ca_pem" {
  value = tls_self_signed_cert.ca.cert_pem
}

output "shared_san" {
  value = tls_cert_request.server.dns_names[0]
}

output "vault_server_cert_pfx" {
  value = tls_locally_signed_cert.server.cert_pfx
}

output "vault_lb_cert_pfx" {
  value = acme_certificate.lb.certificate_p12
}
