terraform {
  backend "azurerm" {
  }
}

provider "azurerm" {
  subscription_id = var.subscription
  features {}
}

provider "google" {
  project = var.project
}