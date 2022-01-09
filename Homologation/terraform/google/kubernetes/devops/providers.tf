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