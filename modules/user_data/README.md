# Azure User Data Module

Generates a script for a VMSS instance to use to install and configure HashiCorp Vault.

## Required variables

* `key_vault_key_name` - Name of Key Vault Key used for unsealing Vault
* `key_vault_name` - Name of Key Vault in which the Vault key & secrets are stored
* `key_vault_secret_id` - ID of Key Vault Secret in which Vault TLS PFX bundle is stored
* `leader_tls_servername` - DNS name to use when checking certificate names of other Vault servers
* `resource_group` - Resource group in which resources will be deployed
* `subscription_id` - ID of Azure subscription
* `tenant_id` - Tenant ID for Azure subscription in which resources are being deployed
* `vault_version` - Version of Vault to deploy
* `vm_scale_set_name` - Name of Virtual Machine Scale Set with which this user data will be deployed

## Example usage

```hcl
data "azurerm_client_config" "current" {}

module "user_data" {
  source = "./modules/user_data"

  key_vault_key_name    = "mykeyname"
  key_vault_name        = "mykeyvaultname"
  key_vault_secret_id   = "https://mykeyvaultname.vault.azure.net/secrets/mykeyvaultsecretname/12ab12ab12ab12ab12ab12ab12ab12ab"
  leader_tls_servername = "vault.server.com"
  subscription_id       = data.azurerm_client_config.current.subscription_id
  tenant_id             = data.azurerm_client_config.current.tenant_id
  vault_version         = "1.8.1"
  vm_scale_set_name     = "dev-vault"

  resource_group = {
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

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_key_vault_key_name"></a> [key\_vault\_key\_name](#input\_key\_vault\_key\_name) | Key vault key for auto-unseal | `string` | n/a | yes |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Azure Key Vault in which the Vault key & secrets are stored | `string` | n/a | yes |
| <a name="input_key_vault_secret_id"></a> [key\_vault\_secret\_id](#input\_key\_vault\_secret\_id) | Key Vault Secret containing the PFX bundle for TLS | `string` | n/a | yes |
| <a name="input_leader_tls_servername"></a> [leader\_tls\_servername](#input\_leader\_tls\_servername) | One of the DNS Subject Alternative Names on the cert in key\_vault\_secret\_id | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Azure resource group in which resources will be deployed | <pre>object({<br>    name = string<br>  })</pre> | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure Subscription ID | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenant ID | `string` | n/a | yes |
| <a name="input_user_supplied_userdata_path"></a> [user\_supplied\_userdata\_path](#input\_user\_supplied\_userdata\_path) | File path to custom VM configuration (i.e. cloud-init config) being supplied by the user | `string` | `null` | no |
| <a name="input_vault_version"></a> [vault\_version](#input\_vault\_version) | Vault version | `string` | n/a | yes |
| <a name="input_vm_identity_client_id"></a> [vm\_identity\_client\_id](#input\_vm\_identity\_client\_id) | https://github.com/hashicorp/vault/issues/7115 | `any` | n/a | yes |
| <a name="input_vm_scale_set_name"></a> [vm\_scale\_set\_name](#input\_vm\_scale\_set\_name) | Name for virtual machine scale set | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vault_userdata_base64_encoded"></a> [vault\_userdata\_base64\_encoded](#output\_vault\_userdata\_base64\_encoded) | n/a |
<!-- END_TF_DOCS -->