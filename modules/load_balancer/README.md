# Azure Load Balancer Module

## Required Variables

* `backend_server_name` - DNS name to use when checking certificate names of other Vault servers
* `health_check_path` - HTTP path to use with Application Gateway health probe
* `identity_ids` - List of user assigned identities to apply to load balancer
* `key_vault_ssl_cert_secret_id` - Secret ID of Key Vault Certificate in which Vault PFX bundle is stored
* `resource_group` - Resource group in which resources will be deployed
* `resource_name_prefix` - Prefix placed before resource names
* `subnet_id` - Subnet in which the load balancer will be deployed

## Example Usage

```hcl
module "load_balancer" {
  source = "./modules/load_balancer"

  backend_server_name          = "vault.server.com"
  health_check_path            = "/v1/sys/health?activecode=200&standbycode=200&sealedcode=200&uninitcode=200"
  key_vault_ssl_cert_secret_id = "https://mykeyvaultname.vault.azure.net/secrets/dev-vault-cert/12ab12ab12ab12ab12ab12ab12ab12ab"
  resource_name_prefix         = "dev"
  subnet_id                    = "/subscriptions/.../resourceGroups/myresourcegroupname/providers/Microsoft.Network/virtualNetworks/myvnetname/subnets/mylbsubnetname"

  identity_ids = [
    "/subscriptions/.../resourceGroups/myresourcegroupname/providers/Microsoft.ManagedIdentity/userAssignedIdentities/dev-vault-lb"
  ]

  resource_group = {
    location = "eastus"
    name     = "myresourcegroupname"
  }
}
```

<!-- BEGIN_TF_DOCS -->
Copyright © 2014-2022 HashiCorp, Inc.

This Source Code is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this project, you can obtain one at http://mozilla.org/MPL/2.0/.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_gateway.vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_public_ip.vault_lb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscale_max_capacity"></a> [autoscale\_max\_capacity](#input\_autoscale\_max\_capacity) | (Optional) Autoscaling capacity unit cap for Application Gateway | `number` | `null` | no |
| <a name="input_autoscale_min_capacity"></a> [autoscale\_min\_capacity](#input\_autoscale\_min\_capacity) | Autoscaling minimum capacity units for Application Gateway (ignored if sku\_capacity is provided) | `number` | `0` | no |
| <a name="input_backend_ca_cert"></a> [backend\_ca\_cert](#input\_backend\_ca\_cert) | (Optional) PEM cert of Certificate Authority to use when verifying health probe SSL traffic | `string` | `null` | no |
| <a name="input_backend_server_name"></a> [backend\_server\_name](#input\_backend\_server\_name) | Hostname to use for backend http setting and health checks | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | (Optional) Map of common tags for all taggable resources | `map(string)` | `{}` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | The endpoint to check for Vault's health status | `string` | n/a | yes |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | User assigned identities to apply to load balancer | `list(string)` | n/a | yes |
| <a name="input_key_vault_ssl_cert_secret_id"></a> [key\_vault\_ssl\_cert\_secret\_id](#input\_key\_vault\_ssl\_cert\_secret\_id) | Key Vault Certificate for listener certificate | `string` | n/a | yes |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | (Optional) Load balancer fixed IPv4 address | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Azure resource group in which resources will be deployed | <pre>object({<br>    location = string<br>    name     = string<br>  })</pre> | n/a | yes |
| <a name="input_resource_name_prefix"></a> [resource\_name\_prefix](#input\_resource\_name\_prefix) | Prefix applied to resource names | `string` | n/a | yes |
| <a name="input_sku_capacity"></a> [sku\_capacity](#input\_sku\_capacity) | (Optional) Fixed (non-autoscaling) number of capacity units for Application Gateway (overrides autoscale\_min\_capacity/autoscale\_max\_capacity variables) | `number` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet where load balancer will be deployed | `string` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | Azure availability zones in which to deploy the Application Gateway | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_address_pool_id"></a> [backend\_address\_pool\_id](#output\_backend\_address\_pool\_id) | n/a |
| <a name="output_public_ip_id"></a> [public\_ip\_id](#output\_public\_ip\_id) | n/a |
<!-- END_TF_DOCS -->