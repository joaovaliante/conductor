/******************************************
	Static IPs
 *****************************************/
module "ingress_static_ip" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/static-ip"
  name                 = "ingress-static-ip"
  gcp_project          = var.project
  region               = var.region
  private_ip           = true
  host_network_project = var.network_project
  host_subnet_name     = var.host_subnet_name
}

/******************************************
	Cluster Kubernetes
 *****************************************/
module "kubernetes" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/kubernetes/cluster-shared-vpc"

  gcp_project                = var.project
  cluster_name               = var.cluster_name
  kubernetes_version         = "1.18.15-gke.1100"
  region                     = var.region
  node_locations             = var.node_locations
  host_vpc_name              = var.host_vpc_name
  host_network_project       = var.network_project
  host_subnet_name           = var.host_subnet_name
  master_ipv4_cidr_block     = "10.75.216.0/28"
  env_services_subnet_name   = "gcp2d-subnet-gke-devops-svc"
  env_pods_subnet_name       = "gcp2d-subnet-gke-devops-pod"
  master_authorized_networks = var.master_authorized_networks
  resource_labels = {
    "centro_custo" : "pci",
    "produto" : "api",
    "processing" : "issuer",
    "ambiente" : "dev-teste",
  }
  node_pools = [{
    name              = "default"
    machine_type      = "n1-standard-4"
    disk_type         = "pd-ssd"
    disk_size_gb      = 32
    node_count        = 1
    min_node_count    = 1
    max_node_count    = 4
    max_pods_per_node = 60
    labels = {
      default = true
    }
  }]
}