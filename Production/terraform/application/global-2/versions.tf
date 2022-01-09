terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.3"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.38"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.0.0"
    }

    rancher2 = {
      source = "rancher/rancher2"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
  required_version = ">= 0.13"
}
