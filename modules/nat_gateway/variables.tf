variable "common_tags" {
  description = "Map of common tags for all taggable resources"
  type        = map(string)
}

variable "resource_group" {
  description = "Azure resource group in which resources will be deployed"

  type = object({
    location = string
    name     = string
  })
}

variable "resource_name_prefix" {
  description = "Prefix for resource names (e.g. \"prod\")"
  type        = string
}

variable "environment" {
  type = string
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet that will be associated to the NAT gateway"
}

variable "product" {}