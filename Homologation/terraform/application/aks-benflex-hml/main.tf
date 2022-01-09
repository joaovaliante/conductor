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
  Helm - Pier Benflex
 *****************************************/
module "helm_benflex_pier" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/application"

  heimdall_enabled               = false
  ingress_nginx_enabled          = true
  ingress_nginx_pier_enabled     = true
  ingress_nginx_default_tls_cert = var.ingress_nginx_default_tls_cert
  ingress_nginx_default_tls_key  = var.ingress_nginx_default_tls_key

  pier_release_name  = "pier"
  pier_version       = var.pier_version
  pier_new_version   = var.pier_new_version
  pier_min_replicas  = 1
  pier_max_replicas  = 3
  pier_chart_version = var.pier_chart_version
  pier_values_contents = [
    templatefile("../../../helm/application/pier/values-pier-benflex.yaml", {
      node_name        = "benflex-pier"
      pier_environment = "HOMOLOG-BENFLEX"
    }),
  ]
}

/******************************************
  Rancher - Pier Project Benflex
 *****************************************/
module "rancher_benflex_pier_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
  cluster_name  = var.cluster_name
  project       = "PIER"
  namespaces    = ["pier", "pier-rabbitmq", "pier-redis"]

  depends_on = [
    module.helm_benflex_pier,
  ]
}

/******************************************
  Helm - Neo Benflex
 *****************************************/
module "helm_benflex_neo" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/neo"

  name      = "neo"
  namespace = "neo"

  values_contents = [
    templatefile("../../../helm/application/neo/values-neo-benflex.yaml", {
      version   = var.neo_version
      node_name = "benflex-neo"
    })
  ]
}

/******************************************
  Rancher - NEO Project Benflex
 *****************************************/
module "rancher_benflex_neo_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
  cluster_name  = var.cluster_name
  project       = "NEO"
  namespaces    = ["neo"]

  depends_on = [
    module.helm_benflex_neo
  ]
}

/******************************************
  Helm - Iris Candidate
 *****************************************/

module "helm_iris_candidate_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/iris"

  name      = "iris"
  namespace = "iris"

  values_contents = [
    templatefile("../../../helm/application/iris/values-iris-benflex.yaml", {
      image             = "conductorcr.azurecr.io/azure-iris/iris-candidate"
      version           = "1.55.0"
      registry_password = var.registry_password
    })
  ]
}

/******************************************
  Rancher - Project Iris
 *****************************************/
module "rancher_iris_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
  cluster_name  = var.cluster_name
  project       = "Iris"
  namespaces    = ["iris"]

  depends_on = [
    module.helm_iris_candidate_application
  ]
}

