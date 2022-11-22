Steps to provision a new Vault cluster:
* Create vnet and subnets
* Create Azure App Gateway - put it behind the firewall?
* Create DNS record and Acme certificate
* Build cluster
* Initialize cluster, store unseal keys and root token in Azure keyvault
* Unseal cluster
* Configure cluster (basic auth method(s), policies, etc)
* Destroy root token
