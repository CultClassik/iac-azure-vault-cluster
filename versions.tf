terraform {
  required_version = ">= 1.3.0"
  required_providers {
    # tls = {
    #   source  = "hashicorp/tls"
    #   version = "~> 3.1.0"
    # }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.31"
    }
    # random = {
    #   source  = "hashicorp/random"
    #   version = "~> 3.4"
    # }
    # acme = {
    #   source  = "vancluever/acme"
    #   version = "~> 2.11.0"
    # }

  }
}
