terraform {
  required_version = ">= 0.13"
  backend "gcs" {
  }
}

provider "azurerm" {
  subscription_id = var.subscription
  features {}
}

provider "google" {
  project = var.project
  region  = var.region
}

provider "google-beta" {
  project = var.project
  region  = var.region
}

provider "helm" {
  kubernetes {
    load_config_file       = false
    cluster_ca_certificate = module.kubernetes.auth_cluster_ca_certificate
    host                   = module.kubernetes.auth_host
    token                  = module.kubernetes.auth_token
  }
}

provider "kubernetes" {
  load_config_file       = false
  cluster_ca_certificate = module.kubernetes.auth_cluster_ca_certificate
  host                   = module.kubernetes.auth_host
  token                  = module.kubernetes.auth_token
}

provider "kubectl" {
  load_config_file       = false
  cluster_ca_certificate = module.kubernetes.auth_cluster_ca_certificate
  host                   = module.kubernetes.auth_host
  token                  = module.kubernetes.auth_token
}

provider "rancher2" {
  api_url   = local.rancher_api_url
  token_key = var.rancher_token
  insecure  = false
}

provider "null" {
}