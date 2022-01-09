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
  rancher_url              = var.rancher_url
  rancher_token            = var.rancher_token
  rancher_base_url         = "https://10.51.15.97"
  rancher_wrong_base_url   = var.rancher_url
  monitoring_chart_version = var.monitoring_chart_version

  node_pools = [{
    name               = "default",
    node_count         = var.machine_min,
    vm_size            = var.machine_type,
    auto_scaling       = true
    min_count          = var.machine_min
    max_count          = var.machine_max
    availability_zones = ["1", "2", "3"]
    node_labels = {
      default = "true"
    }
  }]

  tags = var.tags
}