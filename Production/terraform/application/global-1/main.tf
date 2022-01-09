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
  name                = "AZ2P-INGRESS-AKS-PUBLIC-IP"
  resource_group_name = var.resource_group_name
}

data "azurerm_public_ip" "nginx_ingress_pier" {
  name                = "AZ2P-INGRESS-PIER-AKS-PUBLIC-IP"
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
  ingress_pier_static_ip         = data.azurerm_public_ip.nginx_ingress_pier.ip_address
  ingress_nginx_values_contents = [
    file("../../../helm/application/ingress/values-ingress-nginx.yaml"),
    file("../../../helm/application/ingress/values-ingress-nginx-internal.yaml"),
    file("../../../helm/azure/ingress/values-ingress-nginx.yaml")
  ]
  ingress_nginx_pier_values_contents = [
    file("../../../helm/application/ingress/values-ingress-nginx.yaml"),
    file("../../../helm/application/ingress/values-ingress-nginx-internal.yaml"),
    file("../../../helm/application/ingress/values-ingress-nginx-pier.yaml"),
    file("../../../helm/azure/ingress/values-ingress-nginx.yaml")
  ]

  heimdall_enabled              = var.heimdall_enabled
  heimdall_version              = var.heimdall_version
  heimdall_new_version          = var.heimdall_new_version
  heimdall_min_replicas         = var.heimdall_replicas
  heimdall_new_version_replicas = var.heimdall_new_version_replicas
  heimdall_chart_version        = var.heimdall_chart_version
  heimdall_values_contents = [
    file("../../../helm/application/heimdall/values-heimdall.yaml"),
    file("../../../helm/application/heimdall/values-heimdall-global.yaml"),
    templatefile("../../../helm/application/heimdall/values-heimdall-datadog.yaml", local.pier_data),
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
    templatefile("../../../helm/azure/pier/values-pier.yaml", local.pier_data)
  ]
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

/******************************************
	Prometheus
 *****************************************/
module "prometheus_pier" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/prometheus"

  name         = "pier"
  namespace    = "pier-monitoring"
  displayName  = "Pier"
  retention    = "30d"
  storage      = true
  storage_size = 50 #50GB
  api_base_url = module.rancher_application.rancher_api_proxy_url

  watchNamespaces = [
    "pier-redis",
    "pier-rabbitmq",
    "pier"
  ]
}

module "prometheus_pier_namespace" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/namespace"

  cluster_name  = var.cluster_name
  project       = "pier"
  namespaces    = ["pier-monitoring"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.prometheus_pier
  ]
}

/******************************************
	Mercurio
 *****************************************/
module "helm_agillitas_mercurio" {
  source                  = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/mercurio"
  name                    = "mercurio-agillitas"
  chart_version           = var.mercurio_chart_version
  namespace               = "mercurio-agillitas"
  sms_version             = var.mercurio_sms_version
  push_enabled            = false
  sms_enabled             = true
  app_version             = var.mercurio_app_version["agillitas"]
  app_issuer              = var.mercurio_app_issuer["agillitas"]
  database_connection_uri = var.mercurio_database_connection_uri["agillitas"]
//  cipher_token            = var.mercurio_cipher_token["agillitas"]
  database_password       = var.mercurio_database_password["agillitas"]
  pier_token              = var.mercurio_pier_token["agillitas"]
  splunk_token            = var.mercurio_splunk_token["agillitas"]
  values_contents = [
    templatefile("../../../helm/application/mercurio/values-mercurio.yaml", {
      replicas          = 1
      registry_password = var.mercurio_registry_password
      redis_url         = var.mercurio_agillitas_redis_url
    })
  ]
}
module "helm_c6bank_mercurio" {
  source                  = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/mercurio"
  name                    = "mercurio-c6bank"
  chart_version           = var.mercurio_chart_version
  namespace               = "mercurio-c6bank"
  sms_version             = var.mercurio_sms_version
  push_enabled            = false
  sms_enabled             = true
  app_version             = var.mercurio_app_version["c6bank"]
  app_issuer              = var.mercurio_app_issuer["c6bank"]
  database_connection_uri = var.mercurio_database_connection_uri["c6bank"]
//  cipher_token            = var.mercurio_cipher_token["c6bank"]
  database_password       = var.mercurio_database_password["c6bank"]
  pier_token              = var.mercurio_pier_token["c6bank"]
  splunk_token            = var.mercurio_splunk_token["c6bank"]
  values_contents = [
    templatefile("../../../helm/application/mercurio/values-mercurio.yaml", {
      replicas          = 1
      registry_password = var.mercurio_registry_password
      redis_url         = var.mercurio_c6bank_redis_url
    })
  ]
}
module "helm_fortbrasil_mercurio" {
  source                  = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/mercurio"
  name                    = "mercurio-fortbrasil"
  chart_version           = var.mercurio_chart_version
  namespace               = "mercurio-fortbrasil"
  sms_version             = var.mercurio_sms_version
  push_enabled            = false
  sms_enabled             = true
  app_version             = var.mercurio_app_version["fortbrasil"]
  app_issuer              = var.mercurio_app_issuer["fortbrasil"]
  database_connection_uri = var.mercurio_database_connection_uri["fortbrasil"]
//  cipher_token            = var.mercurio_cipher_token["fortbrasil"]
  database_password       = var.mercurio_database_password["fortbrasil"]
  pier_token              = var.mercurio_pier_token["fortbrasil"]
  splunk_token            = var.mercurio_splunk_token["fortbrasil"]
  values_contents = [
    templatefile("../../../helm/application/mercurio/values-mercurio.yaml", {
      replicas          = 1
      registry_password = var.mercurio_registry_password
      redis_url         = var.mercurio_fortbrasil_redis_url
    })
  ]
}

module "helm_pernambucanas_mercurio" {
  source                  = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/mercurio"
  name                    = "mercurio-pernambucanas"
  chart_version           = var.mercurio_chart_version
  namespace               = "mercurio-pernambucanas"
  push_version            = var.mercurio_push_version
  push_enabled            = true
  sms_enabled             = false
  app_version             = var.mercurio_app_version["pernambucanas"]
  app_issuer              = var.mercurio_app_issuer["pernambucanas"]
  database_connection_uri = var.mercurio_database_connection_uri["pernambucanas"]
  database_password       = var.mercurio_database_password["pernambucanas"]
  pier_token              = var.mercurio_pier_token["pernambucanas"]
  splunk_token            = var.mercurio_splunk_token["pernambucanas"]
  values_contents = [
    templatefile("../../../helm/application/mercurio/values-mercurio.yaml", {
      replicas          = 1
      registry_password = var.mercurio_registry_password
      redis_url         = var.mercurio_pernambucanas_redis_url
    })
  ]
}

module "helm_unicred_mercurio" {
  source                  = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/mercurio"
  name                    = "mercurio-unicred"
  chart_version           = var.mercurio_chart_version
  namespace               = "mercurio-unicred"
  sms_version             = "1.11.21"
  push_enabled            = false
  sms_enabled             = true
  app_version             = var.mercurio_app_version["unicred"]
  app_issuer              = var.mercurio_app_issuer["unicred"]
  database_connection_uri = var.mercurio_database_connection_uri["unicred"]
//  cipher_token            = var.mercurio_cipher_token["unicred"]
  database_password       = var.mercurio_database_password["unicred"]
  pier_token              = var.mercurio_pier_token["unicred"]
  splunk_token            = var.mercurio_splunk_token["unicred"]
  values_contents = [
    templatefile("../../../helm/application/mercurio/values-mercurio.yaml", {
      replicas          = 1
      registry_password = var.mercurio_registry_password
      redis_url         = var.mercurio_unicred_redis_url
    })
  ]
}

module "helm_xpi_mercurio" {
  source                  = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/mercurio"
  name                    = "mercurio-xpi"
  chart_version           = var.mercurio_chart_version
  namespace               = "mercurio-xpi"
  sms_version             = "1.11.21"
  push_enabled            = false
  sms_enabled             = true
  app_version             = var.mercurio_app_version["xpi"]
  app_issuer              = var.mercurio_app_issuer["xpi"]
  database_connection_uri = var.mercurio_database_connection_uri["xpi"]
//  cipher_token            = var.mercurio_cipher_token["xpi"]
  database_password       = var.mercurio_database_password["xpi"]
  pier_token              = var.mercurio_pier_token["xpi"]
  splunk_token            = var.mercurio_splunk_token["xpi"]
  values_contents = [
    templatefile("../../../helm/application/mercurio/values-mercurio.yaml", {
      replicas          = 0
      registry_password = var.mercurio_registry_password
      redis_url         = var.mercurio_xpi_redis_url
    })
  ]
}
module "helm_cbss_mercurio" {
  source                  = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/mercurio"
  name                    = "mercurio-cbss"
  chart_version           = var.mercurio_chart_version
  namespace               = "mercurio-cbss"
  push_version            = var.mercurio_push_version
  push_enabled            = true
  sms_enabled             = false
  app_version             = var.mercurio_app_version["cbss"]
  app_issuer              = var.mercurio_app_issuer["cbss"]
  database_connection_uri = var.mercurio_database_connection_uri["cbss"]
  database_password       = var.mercurio_database_password["cbss"]
  pier_token              = var.mercurio_pier_token["cbss"]
  splunk_token            = var.mercurio_splunk_token["cbss"]
  values_contents = [
    templatefile("../../../helm/application/mercurio/values-mercurio.yaml", {
      replicas          = 1
      registry_password = var.mercurio_registry_password
      redis_url         = var.mercurio_cbss_redis_url
    })
  ]
}


module "rancher_mercurio" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "MERCURIO"
  namespaces    = var.mercurio_namespaces
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
  depends_on = [
    module.helm_agillitas_mercurio, module.helm_c6bank_mercurio,
    module.helm_cbss_mercurio, module.helm_fortbrasil_mercurio,
    module.helm_pernambucanas_mercurio, module.helm_unicred_mercurio, module.helm_xpi_mercurio
  ]
}

/******************************************
  Visa-direct
 *****************************************/
module "helm_visa-direct" {
  name                = "visa-direct"
  source              = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/visa-direct"
  namespace           = "visa-direct"
  application_version = "42822"
  values_contents = [
    templatefile("../../../helm/application/visa-direct/visa-direct.yaml", {
      registry_password   = var.registry_password
      visadirect_username = var.visadirect_username
      visadirect_password = var.visadirect_password
      visadirect_mleidkey = var.visadirect_mleidkey_password

    })
  ]
}

module "rancher_visa-direct" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "visa-direct"
  namespaces    = ["visa-direct"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_visa-direct
  ]
}