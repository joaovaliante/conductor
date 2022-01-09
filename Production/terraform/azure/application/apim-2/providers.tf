terraform {
  required_version = ">= 0.15"
  experiments      = [module_variable_optional_attrs]
  backend "azurerm" {
  }
}

provider "azurerm" {
  subscription_id = var.subscription
  features {}
}