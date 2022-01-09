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
      version = "1.3.2"
    }
  }
  required_version = ">= 0.13"
}
