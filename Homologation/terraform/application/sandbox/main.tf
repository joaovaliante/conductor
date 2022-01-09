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
  name    = "ingress-ip-sandbox"
  project = var.project
  region  = var.region
}

data "google_compute_address" "nginx_ingress_private" {
  name    = "ingress-ip-sandbox-private"
  project = var.project
  region  = var.region
}

/******************************************
	Dock Pier 
 *****************************************/
module "helm_dock_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/application"

  heimdall_enabled               = false
  ingress_nginx_enabled          = true
  ingress_nginx_pier_enabled     = false
  ingress_nginx_default_tls_cert = var.ingress_nginx_default_tls_cert
  ingress_nginx_default_tls_key  = var.ingress_nginx_default_tls_key
  ingress_static_ip              = data.google_compute_address.nginx_ingress.address
  ingress_nginx_values_contents = [
    file("../../../helm/application/ingress/values-ingress-nginx.yaml"),
    file("../../../helm/application/ingress/values-ingress-nginx-internal.yaml"),
    templatefile("../../../helm/google/ingress/values-ingress-nginx-internal.yaml", {
      loadBalancerIP = data.google_compute_address.nginx_ingress_private.address
    })
  ]

  pier_release_name  = "pier-dock"
  pier_version       = "2.213.0"
  pier_new_version   = var.pier_new_version
  pier_min_replicas  = 4
  pier_max_replicas  = 20
  pier_chart_version = var.pier_chart_version
  pier_values_contents = [
    templatefile("../../../helm/application/pier/values-dock-pier.yaml", {
      node_name        = "dock"
      ingress_class    = "nginx"
      pier_dns         = var.pier_dock_dns
      pier_environment = "SANDBOX-DOCK"
    }),
    templatefile("../../../helm/application/pier/values-pier-datadog.yaml", {
      datadog_environment = var.monitoring_datadog_environment
    }),
    templatefile("../../../helm/google/pier/values-pier.yaml", {
      cluster_name = var.cluster_name
    })
  ]
}

/******************************************
	Prometheus
 *****************************************/
module "prometheus_pier" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/prometheus"

  name        = "pier-dock"
  namespace   = "pier-dock-monitoring"
  displayName = "Pier Dock"
  retention   = "30d"
  storage     = false

  watchNamespaces = ["pier-dock", "pier-dock-redis", "pier-dock-rabbitmq"]
}

module "rancher_dock_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/application"

  cluster_name  = var.cluster_name
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  heimdall_enabled          = false
  pier_enabled              = true
  rancher_pier_project_name = "dock-sandbox"
  pier_namespaces           = ["pier-dock", "pier-dock-redis", "pier-dock-rabbitmq"]

  depends_on = [
    module.helm_dock_application
  ]
}
/******************************************
	Arbi Pier
 *****************************************/
module "helm_arbi_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/application"

  heimdall_enabled               = false
  ingress_nginx_enabled          = false
  ingress_nginx_pier_enabled     = false
  ingress_nginx_default_tls_cert = var.ingress_nginx_default_tls_cert
  ingress_nginx_default_tls_key  = var.ingress_nginx_default_tls_key
  pier_release_name              = "pier-arbi"
  pier_version                   = var.pier_version
  pier_new_version               = var.pier_new_version
  pier_min_replicas              = 4
  pier_max_replicas              = 20
  pier_chart_version             = var.pier_chart_version
  pier_values_contents = [
    templatefile("../../../helm/application/pier/values-pier-hmlgi-cdc.yaml", {
      node_name        = "arbi"
      ingress_class    = "nginx"
      pier_dns         = var.pier_arbi_dns
      pier_environment = "SANDBOX-ARBI"
    }),
    templatefile("../../../helm/google/pier/values-pier.yaml", {
      cluster_name = var.cluster_name
    })
  ]
}

module "rancher_arbi_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/application"

  cluster_name  = var.cluster_name
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  heimdall_enabled          = false
  pier_enabled              = true
  rancher_pier_project_name = "arbi-sandbox"
  pier_namespaces           = ["pier-arbi", "pier-arbi-redis", "pier-arbi-rabbitmq"]

  depends_on = [
    module.helm_arbi_application
  ]
}

#################################################################################################
################################## Projeto Migração Sandbox  ####################################
#################################################################################################

/******************************************
  Helm - Sandbox Application
 *****************************************/
#module "helm_pier_sandbox_application" {
#  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/application"

#  heimdall_enabled              = false
#  ingress_nginx_enabled          = false
#  ingress_nginx_pier_enabled     = false
#  ingress_nginx_default_tls_cert = var.ingress_nginx_default_tls_cert
#  ingress_nginx_default_tls_key  = var.ingress_nginx_default_tls_key
#  ingress_nginx_values_contents = [
#    file("../../../helm/application/ingress/values-ingress-nginx.yaml"),
#    file("../../../helm/application/ingress/values-ingress-nginx-internal.yaml")
#  ]

#  pier_release_name  = "sandbox-pier"
#  pier_enabled       = var.sandbox_pier_enabled
#  pier_version       = var.sandbox_pier_version
#  pier_new_version   = var.sandbox_pier_new_version
#  pier_min_replicas  = 1
#  pier_max_replicas  = 3
#  pier_chart_version = var.sandbox_pier_chart_version
#  pier_values_contents = [
#    file("../../../helm/application/pier/values-pier-sandbox-gw.yaml"),
#    file("../../../helm/application/pier/values-pier-sandbox-gw.yaml"),
#    templatefile("../../../helm/google/pier/values-pier.yaml", {
#      cluster_name = var.cluster_name
#    })
#  ]
#}

/******************************************
  Namespace - Vcas
 *****************************************/
resource "kubernetes_namespace" "vcas_app" {
  metadata {
    name = "vcas"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

/******************************************
  Rancher - Project Vcas
 *****************************************/
module "rancher_vcas_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
  cluster_name  = var.cluster_name
  project       = "vcas"
  namespaces    = ["vcas"]

  depends_on = [
    kubernetes_namespace.vcas_app,
  ]
}