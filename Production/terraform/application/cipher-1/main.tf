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
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/kubernetes/data/cluster"

  cluster_name        = var.cluster_name
  resource_group_name = var.resource_group_name
}

/******************************************
	Redis
 *****************************************/
module "redis" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/redis"

  cluster       = true
  replicas      = 3
  name          = "redis"
  namespace     = "redis"
  cluster_name  = var.cluster_name
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
  values_contents = [templatefile("../../../helm/azure/redis/values.yaml", {
    cluster_name = var.cluster_name
  })]
}

/******************************************
	Prometheus
 *****************************************/
module "prometheus_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/prometheus"

  name         = "application"
  namespace    = "monitoring-application"
  displayName  = "Applications"
  retention    = "30d"
  storage      = true
  storage_size = 50 #50GB
  api_base_url = module.redis.rancher_api_proxy_url

  watchNamespaces = [
    "redis"
  ]

  depends_on = [
    module.redis
  ]
}

module "prometheus_namespace" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/namespace"

  cluster_name  = var.cluster_name
  project       = "monitoring"
  namespaces    = ["monitoring-application"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.prometheus_application
  ]
}