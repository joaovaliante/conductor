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
    load_config_file       = false
    cluster_ca_certificate = module.kubernetes.auth_cluster_ca_certificate
    host                   = module.kubernetes.auth_host
    token                  = module.kubernetes.auth_token
  }
}