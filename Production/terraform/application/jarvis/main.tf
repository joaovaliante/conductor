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
	Helm 
 *****************************************/
module "helm_jarvis" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/kafka-jarvis"

  jarvis_version       = var.jarvis_version
  jarvis_new_version   = var.jarvis_new_version
  jarvis_chart_version = var.jarvis_chart_version
  jarvis_values_contents = [
    file("../../../helm/application/jarvis/values-jarvis.yaml"),
    file("../../../helm/azure/jarvis/values-jarvis.yaml")
  ]

  kafka_version       = var.kafka_version
  kafka_new_version   = var.kafka_new_version
  kafka_chart_version = var.kafka_chart_version
  kafka_values_contents = [
    file("../../../helm/application/jarvis/values-kafka.yaml"),
    file("../../../helm/azure/jarvis/values-kafka.yaml")
  ]
  wait_install = false
}

/******************************************
	Jarvis
 *****************************************/
module "rancher_jarvis_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  cluster_name  = var.cluster_name
  project       = var.jarvis_project
  namespaces    = var.jarvis_namespaces
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_jarvis
  ]
}

/******************************************
	Kafka
 *****************************************/
module "rancher_kafka_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  cluster_name  = var.cluster_name
  project       = var.kafka_project
  namespaces    = var.kafka_namespaces
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_jarvis
  ]
}