terraform {
  required_version = ">= 0.13"
  backend "gcs" {
  }
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
    cluster_ca_certificate = module.kubernetes_data.auth_cluster_ca_certificate
    host                   = module.kubernetes_data.auth_host
    token                  = module.kubernetes_data.auth_token
  }
}

provider "kubernetes" {
  cluster_ca_certificate = module.kubernetes_data.auth_cluster_ca_certificate
  host                   = module.kubernetes_data.auth_host
  token                  = module.kubernetes_data.auth_token
}

provider "kubectl" {
  load_config_file       = false
  cluster_ca_certificate = module.kubernetes_data.auth_cluster_ca_certificate
  host                   = module.kubernetes_data.auth_host
  token                  = module.kubernetes_data.auth_token
}

provider "rancher2" {
  api_url   = local.rancher_api_url
  token_key = var.rancher_token
  insecure  = false
}

provider "null" {
}