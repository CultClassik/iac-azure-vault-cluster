variable "environment" {}

variable "arm_subscription_id" {}

variable "location" {}

variable "product" {}

variable "lb_autoscale_max_capacity" {}

variable "lb_autoscale_min_capacity" {}

# variable "lb_sku_capacity" {}

variable "lb_private_ip_address" {}

variable "instance_count" {}

variable "instance_type" {}

variable "vm_image_id" {}

variable "vault_version" {}

variable "network" {}

variable "dns_zone_name" {}

variable "dns_zone_rg_name" {}

variable "azure_client_secret" {
  description = "For the ACME provider"
}
