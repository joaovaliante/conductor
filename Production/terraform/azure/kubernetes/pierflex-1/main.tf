/******************************************
 Locals
  *****************************************/
locals {
  rancher_api_url = "${var.rancher_url}/v3"
}

module "kubernetes" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/kubernetes/cdt-cluster"

  cluster_name             = var.cluster_name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  kubernetes_version       = var.kubernetes_version
  service_principal_id     = var.service_principal_id
  service_principal_secret = var.service_principal_secret
  uptime_sla               = true

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

  node_pools = [{
    name               = "vnextgeral",
    node_count         = var.vnext_geral_min,
    vm_size            = var.vnext_geral_machine_type,
    auto_scaling       = true
    min_count          = var.vnext_geral_min
    max_count          = var.vnext_geral_max
    availability_zones = ["1", "2", "3"]
    node_labels = {
      vnextgeral = "true"
    }
    }, {
    name               = "toknization",
    node_count         = var.vnext_geral_min,
    vm_size            = var.vnext_geral_machine_type,
    auto_scaling       = true
    min_count          = var.vnext_geral_min
    max_count          = var.vnext_geral_max
    availability_zones = ["1", "2", "3"]
    node_labels = {
      vnextgeral = "true"
    }
  }]

  tags = var.tags
}