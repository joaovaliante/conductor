terraform {
  required_version = ">= 0.13"
  backend "azurerm" {
  }
}

provider "azurerm" {
  subscription_id = var.subscription
  features {}
}

provider "helm" {
  kubernetes {
    load_config_file       = false
    host                   = module.kubernetes.auth_host
    username               = module.kubernetes.auth_username
    password               = module.kubernetes.auth_password
    client_certificate     = module.kubernetes.auth_client_certificate
    client_key             = module.kubernetes.auth_client_key
    cluster_ca_certificate = module.kubernetes.auth_cluster_ca_certificate
  }
}

provider "kubernetes" {
  load_config_file       = false
  host                   = module.kubernetes.auth_host
  username               = module.kubernetes.auth_username
  password               = module.kubernetes.auth_password
  client_certificate     = module.kubernetes.auth_client_certificate
  client_key             = module.kubernetes.auth_client_key
  cluster_ca_certificate = module.kubernetes.auth_cluster_ca_certificate
}

provider "kubectl" {
  load_config_file       = false
  host                   = module.kubernetes.auth_host
  username               = module.kubernetes.auth_username
  password               = module.kubernetes.auth_password
  client_certificate     = module.kubernetes.auth_client_certificate
  client_key             = module.kubernetes.auth_client_key
  cluster_ca_certificate = module.kubernetes.auth_cluster_ca_certificate
}

provider "rancher2" {
  api_url   = local.rancher_api_url
  token_key = var.rancher_token
  insecure  = false
}

provider "null" {
}