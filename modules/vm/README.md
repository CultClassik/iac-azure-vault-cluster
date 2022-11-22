# Azure VM Module

## Required Variables

* `identity_ids` - List of user assigned identities to apply to the VMs
* `instance_count` - Number of virtual machines to maintain in the scale set
* `resource_group` - Resource group in which resources will be deployed
* `resource_name_prefix` - Prefix placed before resource names
* `scale_set_name` - Name for virtual machine scale set
* `ssh_public_key` - Public key permitted to access the VM (as `azureuser` by default)
* `subnet_id` - Subnet in which the VMs will be deployed
* `user_data` - User data for virtual machine configuration

## Example Usage

```hcl
module "vm" {
  source = "./modules/vm"

  instance_count       = 5
  resource_name_prefix = "dev"
  scale_set_name       = "dev-vault"
  ssh_public_key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADA..."
  subnet_id            = "/subscriptions/.../resourceGroups/myresourcegroupname/providers/Microsoft.Network/virtualNetworks/myvnetname/subnets/myvaultsubnetname"
  user_data            = base64encode("#!/bin/bash\necho 'starting setup'\n...")

  identity_ids = [
    "/subscriptions/.../resourceGroups/myresourcegroupname/providers/Microsoft.ManagedIdentity/userAssignedIdentities/dev-vault-vm",
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
| [azurerm_linux_virtual_machine_scale_set.vault_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_virtual_machine_scale_set_extension.vault_health](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_scale_set_extension) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_security_group_ids"></a> [application\_security\_group\_ids](#input\_application\_security\_group\_ids) | Application Security Group IDs for the VMs | `list(string)` | `[]` | no |
| <a name="input_backend_address_pool_ids"></a> [backend\_address\_pool\_ids](#input\_backend\_address\_pool\_ids) | List of Backend Address Pools from an Application Gateway to which the virtual machines will be connected | `list(string)` | `null` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | (Optional) Map of common tags for all taggable resources | `map(string)` | `{}` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | The endpoint for scale set health extension checks | `string` | n/a | yes |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | User assigned identities to apply to the VMs | `list(string)` | n/a | yes |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of Vault nodes to deploy in scale set | `number` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Scale set virtual machine SKU | `string` | `"Standard_D2s_v3"` | no |
| <a name="input_os_disk_type"></a> [os\_disk\_type](#input\_os\_disk\_type) | Disk type to use for VM instances | `string` | `"Premium_LRS"` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Azure resource group in which resources will be deployed | <pre>object({<br>    name     = string<br>    location = string<br>  })</pre> | n/a | yes |
| <a name="input_resource_name_prefix"></a> [resource\_name\_prefix](#input\_resource\_name\_prefix) | Prefix applied to resource names | `string` | n/a | yes |
| <a name="input_scale_set_name"></a> [scale\_set\_name](#input\_scale\_set\_name) | Name for virtual machine scale set | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | Public key to use for SSH access to VMs | `string` | n/a | yes |
| <a name="input_ssh_username"></a> [ssh\_username](#input\_ssh\_username) | Instance admin username | `string` | `"azureuser"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet in which VMs will be deployed | `string` | n/a | yes |
| <a name="input_ultra_ssd_enabled"></a> [ultra\_ssd\_enabled](#input\_ultra\_ssd\_enabled) | Enable VM scale set Ultra SSD data disks compatibility | `bool` | `true` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | User data for VM configuration | `string` | n/a | yes |
| <a name="input_user_supplied_source_image_id"></a> [user\_supplied\_source\_image\_id](#input\_user\_supplied\_source\_image\_id) | (Optional) Image ID for Vault instances | `string` | `null` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | Azure availability zones for deployment | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vm_scale_set_name"></a> [vm\_scale\_set\_name](#output\_vm\_scale\_set\_name) | Name of Virtual Machine Scale Set |
<!-- END_TF_DOCS -->