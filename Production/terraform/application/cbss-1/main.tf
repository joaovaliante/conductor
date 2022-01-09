/******************************************
	Locals
 *****************************************/
locals {
  rancher_api_url = "${var.rancher_url}/v3"
  pier_data = {
    datadog_environment  = var.monitoring_datadog_environment
    cluster_name         = var.cluster_name
    registry_password    = var.registry_password
    pier_dns             = var.pier_dns
    pier_environment     = var.pier_environment
    pier_nfs_password    = var.pier_nfs_password
    pier_cep_username    = var.pier_cep_username
    pier_cep_password    = var.pier_cep_password
    pier_harpia_username = var.pier_harpia_username
    pier_harpia_password = var.pier_harpia_password
    pier_db_username     = var.pier_db_username
    pier_db_password     = var.pier_db_password
    pier_quartz_password = var.pier_quartz_password
  }
}

/******************************************
	Data Source
 *****************************************/
module "kubernetes" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/kubernetes/data/cluster"

  cluster_name        = var.cluster_name
  resource_group_name = var.resource_group_name
}

data "azurerm_public_ip" "nginx_ingress" {
  name                = "AZ2P-INGRESS-AKS-CBSS-1-PUBLIC-IP"
  resource_group_name = var.resource_group_name
}

/******************************************
	Harness
 *****************************************/
module "harness" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/kubernetes/harness"
}

/******************************************
	Helm 
 *****************************************/
module "helm" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/application"

  ingress_nginx_enabled          = true
  ingress_nginx_pier_enabled     = true
  ingress_nginx_default_tls_cert = var.ingress_nginx_default_tls_cert
  ingress_nginx_default_tls_key  = var.ingress_nginx_default_tls_key
  ingress_static_ip              = data.azurerm_public_ip.nginx_ingress.ip_address
  ingress_nginx_values_contents = [
    file("../../../helm/application/ingress/values-ingress-nginx.yaml"),
    file("../../../helm/application/ingress/values-ingress-nginx-internal.yaml"),
    file("../../../helm/application/cbss/values-ingress-nginx-heimdall.yaml"),
    file("../../../helm/azure/ingress/values-ingress-nginx.yaml")
  ]
  ingress_nginx_pier_values_contents = [
    file("../../../helm/application/ingress/values-ingress-nginx.yaml"),
    file("../../../helm/application/ingress/values-ingress-nginx-pier.yaml"),
    file("../../../helm/azure/ingress/values-ingress-nginx-local.yaml")
  ]

  heimdall_enabled              = var.heimdall_enabled
  heimdall_version              = var.heimdall_version
  heimdall_new_version          = var.heimdall_new_version
  heimdall_min_replicas         = var.heimdall_replicas
  heimdall_new_version_replicas = var.heimdall_new_version_replicas
  heimdall_chart_version        = var.heimdall_chart_version
  heimdall_values_contents = [
    file("../../../helm/application/heimdall/values-heimdall.yaml"),
    file("../../../helm/application/cbss/values-heimdall.yaml"),
    file("../../../helm/azure/heimdall/values-heimdall.yaml")
  ]

  pier_enabled              = var.pier_enabled
  pier_version              = var.pier_version
  pier_tls_enabled          = length(var.pier_dns) > 0
  pier_new_version          = var.pier_new_version
  pier_min_replicas         = var.pier_replicas
  pier_new_version_replicas = var.pier_new_version_replicas
  pier_chart_version        = var.pier_chart_version
  pier_values_contents = [
    templatefile("../../../helm/application/pier/values-pier.yaml", local.pier_data),
    templatefile("../../../helm/application/pier/values-pier-datadog.yaml", local.pier_data),
    templatefile("../../../helm/azure/pier/values-pier.yaml", local.pier_data),
    file("../../../helm/application/pier/values-pier-defaultBackend.yaml")
  ]

  wait_install = false
}

/******************************************
	Pier and Heimdall
 *****************************************/
module "rancher_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/application"

  cluster_name  = var.cluster_name
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  heimdall_enabled          = module.helm.heimdall_enabled
  pier_enabled              = module.helm.pier_enabled
  heimdall_rancher_endpoint = true
}