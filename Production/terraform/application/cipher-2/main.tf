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

/******************************************
	Mercurio RabbitMQ
 *****************************************/
resource "helm_release" "mercurio_rabbitmq" {
  name             = "mercurio"
  repository       = "https://cdt-helm-application.storage.googleapis.com"
  chart            = "mercurio"
  namespace        = "mercurio"
  version          = "0.1.1"
  create_namespace = true

  values = [
    templatefile("../../../helm/application/mercurio/values-rabbitmq.yaml", {
      registry_password = var.registry_password
      version           = "38988"
    })
  ]
}

/******************************************
	RabbitMQ
 *****************************************/
resource "helm_release" "rabbitmq" {
  name             = "rabbitmq"
  repository       = "https://cdt-helm-application.storage.googleapis.com"
  chart            = "rabbitmq"
  namespace        = "rabbitmq"
  version          = ""
  create_namespace = true

  values = [
    templatefile("../../../helm/azure/rabbitmq/values-rabbitmq-mercurio.yaml", {
      cluster_name = var.cluster_name
    })
  ]
}

module "rancher_mercurio_rabbitmq" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  cluster_name  = var.cluster_name
  project       = "mercurio"
  namespaces    = [helm_release.mercurio_rabbitmq.namespace, helm_release.rabbitmq.namespace]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}

