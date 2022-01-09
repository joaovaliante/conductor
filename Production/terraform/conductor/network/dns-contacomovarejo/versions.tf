terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.59"
    }

    google = {
      source  = "hashicorp/google"
      version = ">=3.67"
    }
  }
  required_version = ">= 0.14"
}
