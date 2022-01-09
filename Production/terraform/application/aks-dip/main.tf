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
	Rancher
 *****************************************/
module "rancher_kafka_prometheus" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Ingestion"
  namespaces    = ["datastore", "logging", "ingestion", "monitoring", "processing", "cicd"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}

/******************************************
	Prometheus
 *****************************************/
module "prometheus_dip_prod" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/prometheus"

  name                  = "dip-kafka-prometheus"
  namespace             = "dip-kafka-monitoring"
  displayName           = "DIP Kafka"
  retention             = "30d"
  storage               = true
  storage_size          = 50 #50GB
  api_base_url          = module.rancher_kafka_prometheus.rancher_api_proxy_url
  alert_manager_enabled = true
  watchNamespaces       = ["datastore", "logging", "ingestion", "monitoring", "processing", "cicd"]

  external_labels = {
    "cluster"  = "AZ1P-AKS-DIP"
    "ambiente" = "DIP-PROD"
    "cloud"    = "Azure"
  }

  depends_on = [
    module.rancher_kafka_prometheus
  ]
}

module "alert_manager_dip_prod" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/alertmanager"

  name          = "dip-kafka-alertmanager"
  namespace     = "dip-kafka-monitoring"
  slack_channel = "#datahub-api"
  slack_api_url = var.slack_api_url
  api_base_url  = module.rancher_kafka_prometheus.rancher_api_proxy_url

  depends_on = [
    module.prometheus_dip_prod
  ]
}

module "prometheus_dipprod_namespace" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/namespace"

  cluster_name  = var.cluster_name
  project       = "Ingestion"
  namespaces    = ["dip-monitoring"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.prometheus_dip_prod
  ]
}
