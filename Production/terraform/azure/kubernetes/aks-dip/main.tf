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
module "rancher_cluster" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/cluster"

  cluster_name     = lower(var.cluster_name)
  kube_auth_raw    = module.kubernetes.auth_kubeconfig_raw
  rancher_base_url = var.rancher_base_url

  # Monitoring
  monitoring_prometheus_enabled = var.monitoring_prometheus_enabled
  rancher_url                   = var.rancher_url
  rancher_token                 = var.rancher_token
  monitoring_chart_version      = var.monitoring_chart_version

  # Alerting
  alert_slack_channel = var.alert_slack_channel
  alert_slack_url     = var.alert_slack_url
  cloud_name          = "azure"

  # Datadog Monitoring
  monitoring_datadog_enabled          = var.monitoring_datadog_enabled
  monitoring_datadog_api_key          = var.monitoring_datadog_api_key
  monitoring_datadog_cloud_provider   = "azure"
  monitoring_datadog_environment      = var.monitoring_datadog_environment
  monitoring_datadog_environment_type = var.monitoring_datadog_environment_type

  depends_on = [
    module.kubernetes
  ]
}
