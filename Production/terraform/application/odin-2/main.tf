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
	Helm Istio
 *****************************************/
module "helm_istio" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/ingress-istio"

  istio_values_contents = [
    file("../../../helm/azure/istio-odin/values-istio.yaml")
  ]

  depends_on = [
    module.kubernetes,
  ]
}

/******************************************
	Helm Odin
 *****************************************/
module "helm_odin" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/odin"

  odin_values_contents = [
    file("../../../helm/application/odin/odin-values.yaml"),
    file("../../../helm/application/odin/odin-2-values.yaml")
  ]

  depends_on = [
    module.helm_istio
  ]
}

/******************************************
	Odin Rancher
 *****************************************/
module "rancher_odin_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  cluster_name  = var.cluster_name
  project       = var.odin_project
  namespaces    = var.odin_namespaces
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_istio,
    module.helm_odin
  ]
}


/******************************************
	Prometheus
 *****************************************/
module "prometheus_odin" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/prometheus"

  name         = "odin"
  namespace    = "odin-monitoring"
  displayName  = "Odin"
  retention    = "30d"
  storage      = true
  storage_size = 50 #50GB
  api_base_url = module.rancher_odin_application.rancher_api_proxy_url

  watchNamespaces = [
    "odin",
    "odin-rabbitmq"
  ]

  depends_on = [
    module.rancher_odin_application,
    module.helm_odin
  ]
}

module "prometheus_odin_namespace" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/namespace"

  cluster_name  = var.cluster_name
  project       = "odin"
  namespaces    = ["odin-monitoring"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.prometheus_odin
  ]
}