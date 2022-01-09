/******************************************
	Locals
 *****************************************/
locals {
  rancher_api_url              = "${var.rancher_url}/v3"
  kafka_splunk_connect_version = "conductorcr.azurecr.io/kafka-connect/splunk:${var.kafka_splunk_connect_version}"
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

data "google_compute_address" "nginx_ingress_public_ip" {
  name    = "gke-ingress-static-public-ip"
  project = var.project
  region  = var.region
}

data "google_compute_address" "nginx_ingress_private_ip" {
  name    = "gke-ingress-static-private-ip"
  project = var.project
  region  = var.region
}

data "azurerm_eventhub_namespace_authorization_rule" "splunk" {
  name                = "splunk"
  resource_group_name = var.resource_group_name
  namespace_name      = "az1p-eventhub-apim"
}

data "azurerm_eventhub_namespace_authorization_rule" "splunk_secondary" {
  name                = "splunk"
  resource_group_name = var.resource_group_name_secondary
  namespace_name      = "az3p-eventhub-apim"
}

data "azurerm_eventhub_namespace_authorization_rule" "benthos" {
  name                = "benthos"
  resource_group_name = var.resource_group_name
  namespace_name      = "az1p-eventhub-apim"
}

data "azurerm_eventhub_namespace_authorization_rule" "benthos_secondary" {
  name                = "benthos"
  resource_group_name = var.resource_group_name_secondary
  namespace_name      = "az3p-eventhub-apim"
}

/******************************************
	NGINX Ingress
 *****************************************/
module "nginx_ingress" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/ingress-nginx"
  name   = "ingress-nginx"

  values_contents = [
    file("../../../helm/application/ingress/values-ingress-nginx.yaml"),
    file("../../../helm/application/ingress/values-ingress-nginx-internal.yaml"),
    file("../../../helm/google/ingress/values-ingress-nginx.yaml"),
    templatefile("../../../helm/application/ingress/values-ingress-nginx-ip.yaml", {
      public_ip  = data.google_compute_address.nginx_ingress_public_ip.address
      private_ip = data.google_compute_address.nginx_ingress_private_ip.address
    }),
  ]
}

/******************************************
	Kafka
 *****************************************/
module "kafka_registry" {
  source   = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/registry"
  for_each = toset(var.kafka_watch_namespaces)

  namespace = each.key
  registries = [{
    name     = "conductorcr"
    server   = "conductorcr.azurecr.io"
    username = "conductorcr"
    password = var.registry_password
  }]
}

module "kafka_operator" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/kafka-operator"

  name             = "kafka-operator"
  chart_version    = "0.23.0"
  watch_namespaces = var.kafka_watch_namespaces

  depends_on = [
    module.kafka_registry
  ]
}

module "rancher_kafka_operator" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  cluster_name  = var.cluster_name
  project       = "kafka-operator"
  namespaces    = ["kafka-operator"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.kafka_operator
  ]
}

module "rancher_kafka" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  cluster_name  = var.cluster_name
  project       = "kafka"
  namespaces    = var.kafka_watch_namespaces
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.kafka_registry
  ]
}

/******************************************
	Splunk Kafka Connector - APIM
 *****************************************/
module "kafka_splunk_connect" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/kubernetes/resource"

  resource_pattern = "${path.root}/../../../manifest/kafka-apim-splunk/*.yaml"
  namespace        = "kafka"
  data = {
    kafka_password            = data.azurerm_eventhub_namespace_authorization_rule.splunk.primary_connection_string
    connect_image             = local.kafka_splunk_connect_version
    connect_replicas          = 2
    connect_bootstrap_servers = var.kafka_splunk_connect_bootstrap_servers
    connect_group_id          = "splunk"
    connect_topic_pattern     = "splunk"
    apim_type                 = "primary"
    max_task                  = 5
    topic_gateway             = "logs-gateway"
    topic_cache               = "logs-cache"
    splunk_uri                = var.kafka_splunk_uri
    splunk_token              = var.kafka_apim_splunk_token
    splunk_source             = var.kafka_apim_splunk_source
    splunk_sourcetype_gateway = var.kafka_apim_splunk_sourcetype_gateway
    splunk_sourcetype_cache   = var.kafka_apim_splunk_sourcetype_cache
  }
}

module "kafka_splunk_connect_secondary" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/kubernetes/resource"

  resource_pattern = "${path.root}/../../../manifest/kafka-apim-splunk/*.yaml"
  namespace        = "kafka"
  data = {
    kafka_password            = data.azurerm_eventhub_namespace_authorization_rule.splunk_secondary.primary_connection_string
    connect_image             = local.kafka_splunk_connect_version
    connect_replicas          = 2
    connect_bootstrap_servers = var.kafka_splunk_connect_bootstrap_servers_secondary
    connect_group_id          = "splunk"
    connect_topic_pattern     = "splunk"
    apim_type                 = "secondary"
    max_task                  = 5
    topic_gateway             = "logs-gateway"
    topic_cache               = "logs-cache"
    splunk_uri                = var.kafka_splunk_uri
    splunk_token              = var.kafka_apim_splunk_token
    splunk_source             = var.kafka_apim_splunk_source
    splunk_sourcetype_gateway = var.kafka_apim_splunk_sourcetype_gateway
    splunk_sourcetype_cache   = var.kafka_apim_splunk_sourcetype_cache
  }
}

/******************************************
	Splunk Kafka Connector - Application Gateway
 *****************************************/
module "kafka_splunk_connect_appgw" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/kubernetes/resource"

  resource_pattern = "${path.root}/../../../manifest/kafka-appgw-splunk/*.yaml"
  namespace        = "kafka"
  data = {
    kafka_password            = data.azurerm_eventhub_namespace_authorization_rule.splunk.primary_connection_string
    connect_image             = local.kafka_splunk_connect_version
    connect_replicas          = 2
    connect_bootstrap_servers = var.kafka_splunk_connect_bootstrap_servers
    connect_group_id          = "splunk-appgw"
    connect_topic_pattern     = "splunk-appgw"
    appgw_type                = "primary"
    max_task                  = 5
    topics                    = "logs-appgw"
    splunk_uri                = var.kafka_splunk_uri
    splunk_token              = var.kafka_appgw_splunk_token
    splunk_source             = var.kafka_appgw_splunk_source
    splunk_sourcetype         = var.kafka_appgw_splunk_sourcetype_access
  }
}

module "kafka_splunk_connect_appgw_secondary" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/kubernetes/resource"

  resource_pattern = "${path.root}/../../../manifest/kafka-appgw-splunk/*.yaml"
  namespace        = "kafka"
  data = {
    kafka_password            = data.azurerm_eventhub_namespace_authorization_rule.splunk_secondary.primary_connection_string
    connect_image             = local.kafka_splunk_connect_version
    connect_replicas          = 2
    connect_bootstrap_servers = var.kafka_splunk_connect_bootstrap_servers_secondary
    connect_group_id          = "splunk-appgw"
    connect_topic_pattern     = "splunk-appgw"
    appgw_type                = "secondary"
    max_task                  = 5
    topics                    = "logs-appgw"
    splunk_uri                = var.kafka_splunk_uri
    splunk_token              = var.kafka_appgw_splunk_token
    splunk_source             = var.kafka_appgw_splunk_source
    splunk_sourcetype         = var.kafka_appgw_splunk_sourcetype_access
  }
}

/******************************************
	Benthos - Application Gateway
 *****************************************/
resource "helm_release" "benthos_appgw" {
  name       = "benthos-appgw"
  repository = "https://cdt-helm-application.storage.googleapis.com"
  chart      = "benthos"
  wait       = true
  namespace  = "kafka"
  version    = ""
  values = [
    templatefile("../../../helm/application/benthos/application-gateway.yaml", {
      event_hub_password_principal = data.azurerm_eventhub_namespace_authorization_rule.benthos.primary_connection_string
      event_hub_password_secondary = data.azurerm_eventhub_namespace_authorization_rule.benthos_secondary.primary_connection_string
    })
  ]
}