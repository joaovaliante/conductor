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
module "ingress_static_ip" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/static-ip"
  name                 = "heimdall-static-ip"
  gcp_project          = var.project
  region               = var.region
  private_ip           = false
  host_network_project = "cdt-network-prd"
  host_subnet_name     = var.host_subnet_name
}

module "ingress_pier_static_ip" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/static-ip"
  name                 = "pier-static-ip"
  gcp_project          = var.project
  region               = var.region
  private_ip           = false
  host_network_project = "cdt-network-prd"
  host_subnet_name     = var.host_subnet_name
}

/******************************************
	Cluster Kubernetes
 *****************************************/
module "kubernetes" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/kubernetes/cdt-application"

  project                    = var.project
  cluster_name               = var.cluster_name
  cluster_version            = "1.18.15-gke.1100"
  region                     = var.region
  node_locations             = var.node_locations
  host_vpc_name              = var.host_vpc_name
  host_network_project       = "cdt-network-prd"
  host_subnet_name           = var.host_subnet_name
  master_cidr_block          = "10.54.64.0/28"
  service_subnet_name        = "gcp2p-subnet-gke-svc-1"
  pod_subnet_name            = "gcp2p-subnet-gke-pod-1"
  master_authorized_networks = var.master_authorized_networks
  rancher_url                = var.rancher_url
  rancher_token              = var.rancher_token
  monitoring_chart_version   = var.monitoring_chart_version

  heimdall_enabled      = var.heimdall_enabled
  heimdall_machine_type = "n1-standard-4"
  heimdall_machine_min  = 1
  heimdall_machine_max  = 30

  pier_enabled      = var.pier_enabled
  pier_machine_type = "n1-standard-4"
  pier_machine_min  = 1
  pier_machine_max  = 30
}