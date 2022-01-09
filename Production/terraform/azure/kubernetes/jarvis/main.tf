/******************************************
	Locals
 *****************************************/
locals {
  rancher_api_url = "${var.rancher_url}/v3"
}

module "kubernetes" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/kubernetes/cdt-kafka-jarvis"

  cluster_name             = var.cluster_name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  kubernetes_version       = var.kubernetes_version
  service_principal_id     = var.service_principal_id
  service_principal_secret = var.service_principal_secret
  uptime_sla               = true
  availability_zones       = ["1", "2", "3"]

  //ssh access
  host_admin_username    = var.host_admin_username
  host_admin_key_content = var.host_admin_key_content

  //subnet
  subnet_name                         = var.subnet_name
  virtual_network_name                = var.virtual_network_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name

  //rancher & monitoring
  rancher_url                         = var.rancher_url
  rancher_token                       = var.rancher_token
  monitoring_chart_version            = var.monitoring_chart_version
  monitoring_datadog_enabled          = true
  monitoring_datadog_api_key          = var.monitoring_datadog_api_key
  monitoring_datadog_environment      = var.monitoring_datadog_environment
  monitoring_datadog_environment_type = var.monitoring_datadog_environment_type

  //apps
  kafka_enabled  = var.kafka_enabled
  jarvis_enabled = var.jarvis_enabled

  tags = var.tags
}