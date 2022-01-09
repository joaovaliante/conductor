/******************************************
	Locals
 *****************************************/
locals {
  rancher_api_url = "${var.rancher_url}/v3"
}

########################
# KUBERNETES MODULE    #
########################
# [Source Code Local]===: AzureDevops -> conductortech (organization) -> Terraform Modules (project) -> 
#                         -> Terraform Modules(repos) -> modules -> azure -> kubernetes -> cdt-cluster  
#
# [Pipeline action]=====: AzureDevops -> Pipeline -> Publish in the GCS Bucket
#
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
  rancher_base_url         = "https://rancher.devcdt.com.br"
  rancher_wrong_base_url   = var.rancher_url
  monitoring_chart_version = var.monitoring_chart_version
  alert_slack_channel      = var.alert_slack_channel
  alert_slack_url          = var.alert_slack_url

  node_pools = [{
    name               = "vnextqa",
    node_count         = var.vnext_geral_qa_min,
    vm_size            = var.vnext_geral_qa_machine_type,
    auto_scaling       = true
    min_count          = var.vnext_geral_qa_min
    max_count          = var.vnext_geral_qa_max
    availability_zones = ["1", "2", "3"]
    node_labels = {
      vnextqa = "true"
    }
  }]

  tags = var.tags
}