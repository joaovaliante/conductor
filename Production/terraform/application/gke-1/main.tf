/******************************************
	Locals
 *****************************************/
locals {
  rancher_api_url = "${var.rancher_url}/v3"
}

/******************************************
	Data Source
 *****************************************/
module "kubernetes" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/kubernetes/data/cluster"

  project      = var.project
  cluster_name = var.cluster_name
  region       = var.region
}

data "google_compute_address" "nginx_ingress" {
  name    = "heimdall-static-ip"
  project = var.project
  region  = var.region
}

data "google_compute_address" "nginx_ingress_pier" {
  name    = "pier-static-ip"
  project = var.project
  region  = var.region
}

/******************************************
	Helm 
 *****************************************/
module "helm" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/application"

  ingress_nginx_enabled          = true
  ingress_nginx_pier_enabled     = true
  ingress_nginx_default_tls_cert = var.ingress_nginx_default_tls_cert
  ingress_nginx_default_tls_key  = var.ingress_nginx_default_tls_key
  ingress_static_ip              = data.google_compute_address.nginx_ingress.address
  ingress_pier_static_ip         = data.google_compute_address.nginx_ingress_pier.address
  ingress_nginx_values_contents = [
    file("../../../helm/application/ingress/values-ingress-nginx.yaml")
  ]
  ingress_nginx_pier_values_contents = [
    file("../../../helm/application/ingress/values-ingress-nginx.yaml"),
    file("../../../helm/application/ingress/values-ingress-nginx-pier.yaml")
  ]

  heimdall_enabled              = var.heimdall_enabled
  heimdall_version              = var.heimdall_version
  heimdall_new_version          = var.heimdall_new_version
  heimdall_min_replicas         = var.heimdall_replicas
  heimdall_new_version_replicas = var.heimdall_new_version_replicas
  heimdall_chart_version        = var.heimdall_chart_version
  heimdall_values_contents = [
    file("../../../helm/application/heimdall/values-heimdall.yaml"),
    file("../../../helm/application/heimdall/values-heimdall-global.yaml"),
    file("../../../helm/google/heimdall/values-heimdall.yaml")
  ]

  pier_enabled              = var.pier_enabled
  pier_version              = var.pier_version
  pier_new_version          = var.pier_new_version
  pier_min_replicas         = var.pier_replicas
  pier_new_version_replicas = var.pier_new_version_replicas
  pier_chart_version        = var.pier_chart_version
  pier_values_contents = [
    file("../../../helm/application/pier/values-pier.yaml"),
    file("../../../helm/google/pier/values-pier.yaml")
  ]
}

/******************************************
	Pier and Heimdall
 *****************************************/
module "rancher_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/application"

  cluster_name  = var.cluster_name
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  heimdall_enabled          = var.heimdall_enabled
  pier_enabled              = var.pier_enabled
  heimdall_rancher_endpoint = true

  depends_on = [
    module.helm
  ]
}