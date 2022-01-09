/******************************************
	Locals
 *****************************************/
locals {
  rancher_api_url = "${var.rancher_url}/v3"
}

/******************************************
	Recursos básicos
 *****************************************/
module "base-project" {
  source          = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/kubernetes/project"
  project         = var.project
  network_project = "cdt-network-prd"
}

/******************************************
	Static IPs
 *****************************************/
module "ingress_static_public_ip" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/static-ip"
  name                 = "gke-ingress-static-public-ip"
  gcp_project          = var.project
  region               = var.region
  private_ip           = false
  host_network_project = "cdt-network-prd"
  host_subnet_name     = var.host_subnet_name
}

module "ingress_static_private_ip" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/static-ip"
  name                 = "gke-ingress-static-private-ip"
  gcp_project          = var.project
  region               = var.region
  private_ip           = true
  host_network_project = "cdt-network-prd"
  host_subnet_name     = var.host_subnet_name
}

/******************************************
	Cluster Kubernetes
 *****************************************/
module "kubernetes" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/kubernetes/cdt-cluster"

  project                    = var.project
  cluster_name               = var.cluster_name
  cluster_version            = "1.19.11-gke.2100"
  region                     = var.region
  node_locations             = var.node_locations
  host_vpc_name              = var.host_vpc_name
  host_network_project       = "cdt-network-prd"
  host_subnet_name           = var.host_subnet_name
  master_cidr_block          = "10.54.64.16/28"
  service_subnet_name        = "gcp2p-subnet-gke-infra-2-svc"
  pod_subnet_name            = "gcp2p-subnet-gke-infra-2-pod"
  master_authorized_networks = var.master_authorized_networks
  rancher_url                = var.rancher_url
  rancher_token              = var.rancher_token
  resource_labels            = { "centro_custo" : "cloud", "produto" : "cloud_kubernetes", "processing" : "issuer", "ambiente" : "producao" }
  monitoring_chart_version   = var.monitoring_chart_version

  node_pools = [{
    name              = "default"
    machine_type      = "n1-standard-4"
    disk_type         = "pd-ssd"
    disk_size_gb      = 32
    node_count        = 1
    min_node_count    = 1
    max_node_count    = 30
    max_pods_per_node = 60
  }]
}