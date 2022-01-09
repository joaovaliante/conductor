/******************************************
	Locals
 *****************************************/
locals {
  rancher_api_url = "${var.rancher_url}/v3"
}

/******************************************
	Cluster Kubernetes
 *****************************************/
module "kubernetes" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/kubernetes/cdt-cluster"

  project                    = var.project
  cluster_name               = var.cluster_name
  cluster_version            = "1.18.17-gke.100"
  region                     = var.region
  node_locations             = var.node_locations
  host_vpc_name              = var.host_vpc_name
  host_network_project       = var.network_project
  host_subnet_name           = var.host_subnet_name
  master_cidr_block          = "10.75.216.32/28"
  service_subnet_name        = "gcp2d-subnet-gke-cluster-hmli-services"
  pod_subnet_name            = "gcp2d-subnet-gke-cluster-hmli-pod"
  master_authorized_networks = var.master_authorized_networks
  resource_labels = {
    "centro_custo" : "pci",
    "produto" : "api",
    "processing" : "issuer",
    "ambiente" : "dev-teste",
  }

  //rancher & monitoring
  rancher_url                         = var.rancher_url
  rancher_token                       = var.rancher_token
  alert_slack_channel                 = var.alert_slack_channel
  alert_slack_url                     = var.alert_slack_url
  monitoring_chart_version            = var.monitoring_chart_version
  monitoring_datadog_enabled          = false
  monitoring_datadog_api_key          = var.monitoring_datadog_api_key
  monitoring_datadog_environment      = var.monitoring_datadog_environment
  monitoring_datadog_environment_type = var.monitoring_datadog_environment_type

  node_pools = [{
    name              = "default"
    machine_type      = "n1-standard-4"
    disk_type         = "pd-ssd"
    disk_size_gb      = 32
    node_count        = 1
    min_node_count    = 1
    max_node_count    = 3
    max_pods_per_node = 60
    labels = {
      default = true
    }
    }, {
    name              = "cdc"
    machine_type      = "n1-standard-4"
    disk_type         = "pd-ssd"
    disk_size_gb      = 32
    node_count        = 1
    min_node_count    = 1
    max_node_count    = 3
    max_pods_per_node = 60
    labels = {
      cdc = true
    }
  }]
}