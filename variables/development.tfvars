product                   = "vault"
location                  = "eastus"
environment               = "development"
dns_zone_parent_name      = "dev.verituityplatform.com"
dns_zone_parent_rg_name   = "common"
lb_autoscale_max_capacity = 3
lb_autoscale_min_capacity = 1
# lb_sku_capacity = <number>
lb_private_ip_address = "172.16.15.126" # see if we can get this using a function instead of hard-coding
# lb_subnet_id # - using output from subnet resource, future use pull from remote state in networking workspace

instance_count = 1
instance_type  = "Standard_D2s_v3"

vault_version = "1.12.1-1"

network = {
  address_space        = ""
  vault_address_prefix = ""
  lb_address_prefix    = ""
}

vm_image_id = "18.04-LTS"
