terraform {
  required_version = ">= 0.14"
  backend "azurerm" {
  }
}

provider "azurerm" {
  subscription_id = var.subscription
  features {}
}