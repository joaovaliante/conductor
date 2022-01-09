terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=3.40"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">=3.40"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">=1.3.2"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=1.13.3"

    }

    null = {
      source  = "hashicorp/null"
      version = ">=3.0.0"

    }

    rancher2 = {
      source  = "rancher/rancher2"
      version = ">=1.11.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
  required_version = ">= 0.14"
}
