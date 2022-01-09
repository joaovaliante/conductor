/******************************************
	Locals
 *****************************************/
locals {
  rancher_api_url = "${var.rancher_url}/v3"
}

module "kubernetes" {
  # source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/kubernetes/cdt-cluster"
  source = "/Users/silvio.junior/Sandbox/terraform-modules/modules/azure/kubernetes/cdt-cluster"

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

module "ingress_nginx" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/ingress-nginx"

  replicas      = 2
  minReplicas   = 2
  chart_version = "3.23.0"
  values_contents = [
    file("../../../../helm/application/ingress/values-ingress-nginx-internal.yaml"),
    file("../../../../helm/azure/ingress/values-ingress-nginx-internal.yaml")
  ]

  depends_on = [
    module.kubernetes
  ]
}

resource "helm_release" "pier" {
  name       = "pier"
  repository = "https://cdt-helm-application.storage.googleapis.com"
  chart      = "pier"
  version    = "1.1.2"
  values = [
    file("/Users/silvio.junior/Downloads/pier-values.yaml")
  ]

  depends_on = [
    module.kubernetes
  ]
}

/******************************************
	Rancher
 *****************************************/
module "rancher_pier" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "pier"
  namespaces    = ["pier", "pier-redis", "pier-rabbitmq"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    helm_release.pier
  ]
}