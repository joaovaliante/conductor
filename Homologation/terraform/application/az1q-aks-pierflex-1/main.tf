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
  source              = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/kubernetes/data/cluster"
  cluster_name        = var.cluster_name
  resource_group_name = var.resource_group_name
}
/******************************************
 	Istio Namespace
  *****************************************/
resource "kubernetes_namespace" "istio-system" {
  metadata {
    name = var.istio_namespace
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}
module "istio_namespace" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Istio-system"
  namespaces    = ["istio-system"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Istio
  *****************************************/
data "kubectl_file_documents" "istio-manifests" {
  content = file("${path.module}/../../../manifest/istio/istio.yaml")
}
resource "kubectl_manifest" "istio" {
  count              = length(data.kubectl_file_documents.istio-manifests.documents)
  yaml_body          = element(data.kubectl_file_documents.istio-manifests.documents, count.index)
  override_namespace = var.istio_namespace
  depends_on = [
    module.istio_namespace
  ]
}
/******************************************
 	Istio Gateway Namespace
  *****************************************/
resource "kubernetes_namespace" "inbound" {
  metadata {
    name = var.istio_gateway_namespace
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}
module "istio_gateway_namespace" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Inbound"
  namespaces    = ["inbound"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
  depends_on = [
    resource.kubernetes_namespace.inbound
  ]
}
/******************************************
 	Istio Gateway
  *****************************************/
data "kubectl_file_documents" "istio-gateway-manifests" {
  content = file("${path.module}/../../../manifest/istio-gateway/gateway.yaml")
}
resource "kubectl_manifest" "istio-gateway" {
  count              = length(data.kubectl_file_documents.istio-gateway-manifests.documents)
  yaml_body          = element(data.kubectl_file_documents.istio-gateway-manifests.documents, count.index)
  override_namespace = var.istio_gateway_namespace
  depends_on = [
    module.istio_gateway_namespace
  ]
}
/******************************************
 	Observability - Prometheus
  *****************************************/
data "kubectl_file_documents" "prometheus-manifests" {
  content = file("${path.module}/../../../manifest/prometheus/prometheus.yaml")
}
resource "kubectl_manifest" "prometheus" {
  count     = length(data.kubectl_file_documents.prometheus-manifests.documents)
  yaml_body = element(data.kubectl_file_documents.prometheus-manifests.documents, count.index)
  depends_on = [
    module.istio_namespace
  ]
}
/******************************************
 	Observability - Grafana
  *****************************************/
data "kubectl_file_documents" "grafana-manifests" {
  content = file("${path.module}/../../../manifest/grafana/grafana.yaml")
}
resource "kubectl_manifest" "grafana" {
  count     = length(data.kubectl_file_documents.grafana-manifests.documents)
  yaml_body = element(data.kubectl_file_documents.grafana-manifests.documents, count.index)
  depends_on = [
    module.istio_namespace
  ]
}
/******************************************
 	Observability - Jaeger
  *****************************************/
data "kubectl_file_documents" "jaeger-manifests" {
  content = file("${path.module}/../../../manifest/jaeger/jaeger.yaml")
}
resource "kubectl_manifest" "jaeger" {
  count     = length(data.kubectl_file_documents.jaeger-manifests.documents)
  yaml_body = element(data.kubectl_file_documents.jaeger-manifests.documents, count.index)
  depends_on = [
    module.istio_namespace
  ]
}
/******************************************
 	Observability - Kiali
  *****************************************/
data "kubectl_file_documents" "kiali-manifests" {
  content = file("${path.module}/../../../manifest/kiali/kiali.yaml")
}
resource "kubectl_manifest" "kiali" {
  count     = length(data.kubectl_file_documents.kiali-manifests.documents)
  yaml_body = element(data.kubectl_file_documents.kiali-manifests.documents, count.index)
  depends_on = [
    module.istio_namespace
  ]
}

/******************************************
 	Pierflex Namespaces
  *****************************************/
resource "kubernetes_namespace" "pierflex_namespaces" {
  count = length(var.pierflex_namespaces)
  metadata {
    name = element(var.pierflex_namespaces, count.index).name
    annotations = {
      name = element(var.pierflex_namespaces, count.index).name
    }
    labels = {
      "app.kubernetes.io/instance"   = element(var.pierflex_namespaces, count.index).name
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = element(var.pierflex_namespaces, count.index).name
      "istio-injection"              = element(var.pierflex_namespaces, count.index).istio
    }
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

/******************************************
 	Rancher Project - Tokenization
  *****************************************/
module "rancher_tokenization_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Tokenization"
  namespaces    = ["tokenization"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Rancher Project - Account
  *****************************************/
module "rancher_account_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Account"
  namespaces    = ["account"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Rancher Project - Aggregator
  *****************************************/
module "rancher_aggregator_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Aggregator"
  namespaces    = ["aggregator"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Rancher Project - Billing
  *****************************************/
module "rancher_billing_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Billing"
  namespaces    = ["billing"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Rancher Project - Cipher
  *****************************************/
module "rancher_cipher_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Cipher"
  namespaces    = ["cipher"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Rancher Project - Control
  *****************************************/
module "rancher_control_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Control"
  namespaces    = ["control"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Rancher Project - Events
  *****************************************/
module "rancher_events_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Events"
  namespaces    = ["events"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Rancher Project - Exchange
  *****************************************/
module "rancher_exchange_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Exchange"
  namespaces    = ["exchange"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Rancher Project - Falcon-Connector
  *****************************************/
module "rancher_falcon_connector_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Falcon-connector"
  namespaces    = ["falcon-connector"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Rancher Project -  Falcon Card
  *****************************************/
module "rancher_falcon_card_connector_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Falcon-card-connector"
  namespaces    = ["falcon-card-connector"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Rancher Project -  Issuer
  *****************************************/
module "rancher_issuer_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Issuer"
  namespaces    = ["issuer"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Rancher Project -  Operation
  *****************************************/
module "rancher_operation_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Operation"
  namespaces    = ["operation"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Rancher Project - Orchestrator
  *****************************************/
module "rancher_orchestrator_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Orchestrator"
  namespaces    = ["orchestrator"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Rancher Project - Person
  *****************************************/
module "rancher_person_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Person"
  namespaces    = ["person"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Rancher Project - Piercards
  *****************************************/
module "rancher_piercards_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Piercards"
  namespaces    = ["piercards"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Rancher Project - Product
  *****************************************/
module "rancher_product_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Product"
  namespaces    = ["product"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Rancher Project - Statement
  *****************************************/
module "rancher_statement_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Statement"
  namespaces    = ["statement"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Rancher Project - Transaction
  *****************************************/
module "rancher_transaction_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Transaction"
  namespaces    = ["transaction"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Rancher Project - Vhub
  *****************************************/
module "rancher_vhub_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Vhub"
  namespaces    = ["vhub"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}
/******************************************
 	Rancher Project - Bankslip
  *****************************************/
module "rancher_bankslip_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Bankslip"
  namespaces    = ["bankslip"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
}

/******************************************
 	Harness Cloud Provider Connect
  *****************************************/
resource "random_id" "secret_id" {
  byte_length = 4
}

module "harness_cloud_provider_kubernetes" {
  source                                  = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/harness/cloud-provider-kubernetes"
  create_sa                               = true
  create_harness_secret                   = true
  sa_name                                 = "harness-sa"
  kubernetes_api_url                      = module.kubernetes.auth_host
  harness_secret_name                     = "azure-pierflex-qa-1-service-account-${random_id.secret_id.hex}"
  harness_secret_manager_id               = var.harness_secret_manager_id
  cloudprovider_name                      = "Azure QA Pierflex-1"
  harness_application_id                  = var.harness_application_id
  harness_secret_scope_environment_filter = "NON_PRODUCTION_ENVIRONMENTS"
  environment_id                          = var.environment_id
  cluster_name                            = var.cluster_name
}