/******************************************
	Local
 *****************************************/
locals {
  rancher_url     = "https://${var.rancher_hostname}"
  rancher_api_url = "${local.rancher_url}/v3"
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
  name    = "ingress-static-ip"
  project = var.project
  region  = var.region
}

/******************************************
	Ingress NGINX 
 *****************************************/
module "ingress_nginx" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/ingress-nginx"

  replicas      = 2
  minReplicas   = 2
  chart_version = "3.23.0"
  values_contents = [
    file("../../../helm/application/ingress/values-ingress-nginx-internal.yaml"),
    templatefile("../../../helm/google/ingress/values-ingress-nginx-internal.yaml", {
      loadBalancerIP = data.google_compute_address.nginx_ingress.address
    })
  ]

  depends_on = [
    module.kubernetes
  ]
}

/******************************************
	Rancher
 *****************************************/
resource "kubernetes_namespace" "rancher" {
  metadata {
    name = var.rancher_namespace
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

resource "kubernetes_secret" "rancher_tls" {
  metadata {
    name      = "tls-rancher-ingress"
    namespace = var.rancher_namespace
  }

  type = "kubernetes.io/tls"
  data = {
    "tls.crt" = base64decode(var.rancher_tls_cert)
    "tls.key" = base64decode(var.rancher_tls_key)
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

resource "helm_release" "rancher" {
  name       = "rancher"
  repository = "https://releases.rancher.com/server-charts/stable"
  chart      = "rancher"
  namespace  = var.rancher_namespace
  values = [
    templatefile("../../../helm/application/rancher/values.yaml", {
      rancher_hostname = var.rancher_hostname
      rancher_version  = var.rancher_version
    })
  ]

  depends_on = [
    module.ingress_nginx,
    kubernetes_namespace.rancher
  ]
}

/******************************************
	Harness
 *****************************************/
resource "helm_release" "harness_delegate" {
  name       = "harness-delegate"
  repository = "https://app.harness.io/storage/harness-download/harness-helm-charts"
  chart      = "harness-delegate"
  values = [
    templatefile("../../../helm/application/harness/delegate-values.yaml", {
      accountId            = var.harness_account_id
      accountSecret        = var.harness_account_secret
      delegateName         = "non-production-kubernetes"
      delegateProfile      = var.harness_delegate_profile
      managerServiceSecret = var.harness_manager_service_secret
    })
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

/******************************************
	Splunk Kafka Connector - Pier
 *****************************************/
module "kafka_splunk_connect" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/kubernetes/resource"

  resource_pattern = "${path.root}/../../../manifest/pier-kafka-splunk/*.yaml"
  namespace        = "kafka"
  data = {
    kafka_password            = var.kafka_connection_string
    connect_image             = "conductorcr.azurecr.io/kafka-connect/splunk:2.8.0"
    connect_replicas          = 1
    connect_bootstrap_servers = var.kafka_splunk_connect_bootstrap_servers
    connect_group_id          = "splunk"
    max_task                  = 5
    splunk_uri                = var.kafka_splunk_uri
    splunk_token              = var.kafka_apim_splunk_token
    splunk_source             = "kafka-connect"
    splunk_sourcetype         = "kafka"
  }
}
