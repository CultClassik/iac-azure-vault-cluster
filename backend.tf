terraform {
  backend "azurerm" {
    container_name       = "terraform-state"
    key                  = "iac-azure-vault-cluster.tfstate"
    resource_group_name  = "tfstate-rg-mgt-prd-eastus2"
    storage_account_name = "tfstatemgtprd"
    subscription_id      = "a75c42cc-a976-4b30-95c6-aba1c6886cba"
  }
}