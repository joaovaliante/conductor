terraform {
  required_version = ">= 0.13"
  backend "gcs" {
  }
}

provider "google" {
  project = var.project
  region  = var.region
  version = "3.24"
}

provider "google-beta" {
  project = var.project
  region  = var.region
  version = "3.24"
}
