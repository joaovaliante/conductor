/******************************************
	Recursos básicos
 *****************************************/
module "base-project" {
  source                = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/project"
  project               = var.project
  project_services_apis = var.project_services_apis
}

/******************************************
	VPC e Shared VPC
 *****************************************/
module "shared-vpc-maskdb" {
  source       = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/shared-vpc"
  host_project = var.project
  vpc_name     = "gcp2p-maskdb-vpc"
}

module "shared-vpc-main" {
  source       = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/shared-vpc"
  host_project = var.project
  vpc_name     = "gcp2p-prd-vpc"
}

/******************************************
	Subnets
 *****************************************/
module "gcp2p-subnet-infra" {
  source      = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/subnet"
  vpc_id      = module.shared-vpc-main.vpc.id
  region      = var.region
  cidr_range  = "10.54.10.0/24"
  subnet_name = "gcp2p-subnet-infra"
}

module "gcp2p-subnet-monitoramento" {
  source      = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/subnet"
  vpc_id      = module.shared-vpc-main.vpc.id
  region      = var.region
  cidr_range  = "10.54.20.0/24"
  subnet_name = "gcp2p-subnet-monitoramento"
}

module "gcp2p-subnet-loadbalance-http" {
  source      = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/subnet"
  vpc_id      = module.shared-vpc-main.vpc.id
  region      = var.region
  cidr_range  = "10.54.25.0/24"
  subnet_name = "gcp2p-subnet-loadbalance-http"
  purpose     = "INTERNAL_HTTPS_LOAD_BALANCER"
  role        = "ACTIVE"
}

module "gcp2p-subnet-maskdb" {
  source      = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/subnet"
  vpc_id      = module.shared-vpc-maskdb.vpc.id
  region      = var.region
  cidr_range  = "10.54.30.0/24"
  subnet_name = "gcp2p-subnet-maskdb"
}

module "gcp2p-subnet-db-az-gcp" {
  source      = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/subnet"
  vpc_id      = module.shared-vpc-main.vpc.id
  region      = var.gke_region
  cidr_range  = "10.54.16.0/28"
  subnet_name = "gcp2p-subnet-db-az-gcp"
}

# Kubernetes Subnets
module "gcp2p-subnet-gke-1" {
  source                   = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/subnet"
  vpc_id                   = module.shared-vpc-main.vpc.id
  region                   = var.gke_region
  private_ip_google_access = true
  cidr_range               = "10.54.32.0/20"
  subnet_name              = "gcp2p-subnet-gke-1"
  secondary_ip_ranges = [
    { ip_cidr_range = "10.55.0.0/16", range_name = "gcp2p-subnet-gke-pod-1" },
    { ip_cidr_range = "10.54.48.0/20", range_name = "gcp2p-subnet-gke-svc-1" },
  ]
}

module "gcp2p-subnet-gke-infra-2" {
  source                   = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/subnet"
  vpc_id                   = module.shared-vpc-main.vpc.id
  region                   = var.gke_region
  private_ip_google_access = true
  cidr_range               = "10.54.80.0/20"
  subnet_name              = "gcp2p-subnet-gke-infra-2"
  secondary_ip_ranges = [
    { ip_cidr_range = "10.56.0.0/16", range_name = "gcp2p-subnet-gke-infra-2-pod" },
    { ip_cidr_range = "10.54.96.0/20", range_name = "gcp2p-subnet-gke-infra-2-svc" },
  ]
}

/******************************************
	VPC Access Connector
 *****************************************/
resource "google_vpc_access_connector" "connector" {
  name          = "vpc-conec-monitoring"
  region        = var.region
  ip_cidr_range = "10.54.21.0/28"
  network       = module.shared-vpc-main.vpc.name
}

/******************************************
	VPC Peering Dev
 *****************************************/
module "gcp2p-maskdb-dev-hml-peering" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/vpc-peering"
  name                 = "gcp2p-maskdb-dev-hml-peering"
  vpc_id               = module.shared-vpc-maskdb.vpc.id
  peer_vpc_id          = "projects/cdt-network-dev/global/networks/gcpd-vpc"
  import_custom_routes = false
}
/******************************************
	VPC Peering PRD
 *****************************************/
module "gcp2p-maskdb-prd-peering" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/vpc-peering"
  name                 = "gcp2p-maskdb-to-prd"
  vpc_id               = module.shared-vpc-maskdb.vpc.id
  peer_vpc_id          = module.shared-vpc-main.vpc.id
  export_custom_routes = false
  import_custom_routes = true

}
module "gcp2p-prd-to-maskb-peering" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/vpc-peering"
  name                 = "gcp2p-prd-to-maskdb"
  vpc_id               = module.shared-vpc-main.vpc.id
  peer_vpc_id          = module.shared-vpc-maskdb.vpc.id
  import_custom_routes = false
  export_custom_routes = true

}

/******************************************
	VPC NAT
 *****************************************/
module "gcp2p-maskdb-nat" {
  source  = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/nat-gateway"
  name    = "maskdb-internet"
  vpc_id  = module.shared-vpc-maskdb.vpc.id
  region  = var.region
  project = var.project
}

module "gcp2p-prd-nat" {
  source    = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/nat-gateway"
  name      = "prd-${var.region}-internet"
  vpc_id    = module.shared-vpc-main.vpc.id
  region    = var.region
  static_ip = true
  project   = var.project
}

module "gcp2p-prd-gke-nat" {
  source    = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/nat-gateway"
  name      = "prd-${var.gke_region}-internet"
  vpc_id    = module.shared-vpc-main.vpc.id
  region    = var.gke_region
  static_ip = true
  project   = var.project
}

/******************************************
	VPNs
 *****************************************/
module "external-ip-gcp2p" {
  source           = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/global-external-ip"
  region           = var.region
  project          = var.project
  external_ip_name = "gcp2p-vpn-azure-external-ip"
  labels           = { "application" : "vpn", "centro_custo" : "cloud", "produto" : "cloud_network", "processing" : "issuer" }
}

// module gcp2p-vpn-azure-us-east1 {
//   source                = "./modules/network-modules/classic-vpn"
//   region                = var.region
//   project               = var.project
//   prefix                = "gcp2p"
//   vpc_name              = module.shared-vpc.vpc.name
//   external_ip_address   = module.external-ip-gcp2p-vpn-azure.external_ip_address
//   firewall_ranges_allow = ["10.70.0.0/16", "10.16.0.0/24","10.60.0.0/16", "10.19.21.0/24", "10.5.0.0/16", "10.7.12.0/24", "10.9.0.0/16", "10.13.0.0/16", "10.19.20.0/24", "10.19.247.0/24", "10.19.248.0/23"]
//   tuneis                = var.tuneis
//   labels                = { "centro_custo" : "cloud", "produto" : "vpn", "processing" : "issuer" }
// }

/******************************************
	Firewall Rules
 *****************************************/
module "allow-forwarding-dns-google-to-ad" {
  source            = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/firewall-rule"
  project           = var.project
  vpc_name          = module.shared-vpc-main.vpc.name
  rule_name         = "gcp2p-allow-forwarding-dns-google-to-ad"
  description       = "Regra que permite a subnet de ingress do google para forwarding de DNS seja liberado para o AD."
  source_ranges     = ["35.199.192.0/19"]
  target_tags       = ["ad"]
  allowed_ports_tcp = ["53"]
  allowed_ports_udp = ["53"]
}

module "allow-azureinfra-to-google-infra" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/firewall-rule"
  project       = var.project
  vpc_name      = module.shared-vpc-main.vpc.name
  rule_name     = "gcp2p-allow-azureinfra-to-google-infra"
  description   = "Regra que permite a subnet de infra na azure se comunique com as maquinas que tenham a network tag: gcpinfra."
  target_tags   = ["gcpinfra"]
  source_ranges = ["10.50.10.0/23", "10.51.10.0/24"]
}

module "allow-onpreminfra-to-google-infra" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/firewall-rule"
  project       = var.project
  vpc_name      = module.shared-vpc-main.vpc.name
  rule_name     = "gcp2p-allow-onpreminfra-to-google-infra"
  description   = "Regra que permite a ranges de infra onprem se comuniquem com as maquinas que tenham a network tag: infra."
  target_tags   = ["infra"]
  source_ranges = ["10.19.247.0/24", "10.19.248.0/23", "10.13.21.0/24", "10.5.1.0/24", "10.9.21.0/24", "10.16.0.0/24", "10.19.255.0/24"]
}

module "allow-ads-to-receive-connections" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/firewall-rule"
  project       = var.project
  vpc_name      = module.shared-vpc-main.vpc.name
  rule_name     = "gcp2p-allow-ads-to-receive-connections"
  description   = "Regra que permite com que o AD receba conneccoes da range que armazena as maquinas intermediarias do maskdb."
  target_tags   = ["ad"]
  source_ranges = ["10.54.10.0/24"]
}

module "allow-comunication-mdbstg" {
  source      = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/firewall-rule"
  project     = var.project
  vpc_name    = module.shared-vpc-maskdb.vpc.name
  rule_name   = "gcp2d-allow-mdbstg"
  description = "Regra que permite com que as maquinas com a tag mdbstg se comuniquem entre si."
  source_tags = ["mdbstg"]
  target_tags = ["mdbstg"]
}

module "gcp2d-allow-maskdb-from-dev-access" {
  source            = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/firewall-rule"
  project           = var.project
  vpc_name          = module.shared-vpc-maskdb.vpc.name
  rule_name         = "gcp2d-allow-maskdb-from-dev-access"
  allowed_ports_tcp = ["39", "445", "1433", "3389", "5985", "5986", "139", "8080", "8081"]
  allowed_ports_udp = []
  description       = "Regra que permite com que as maskdbs se comuniquem com a VPC."
  source_ranges     = ["10.19.247.0/24", "10.19.248.0/23", "10.75.45.208/28"]

}

module "allow-azureinfra-to-google-infra-masdbvpc" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/firewall-rule"
  project       = var.project
  vpc_name      = module.shared-vpc-maskdb.vpc.name
  rule_name     = "gcp2p-allow-azureinfra-to-maskdb-vpc"
  description   = "Regra que permite a subnet de infra na azure se comunique com as maquinas que tenham a network tag: infra."
  source_ranges = ["10.50.10.0/23", "10.54.10.0/24"]
}

module "allow-gcp-hc-to-connect" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/firewall-rule"
  project       = var.project
  vpc_name      = module.shared-vpc-main.vpc.name
  rule_name     = "allow-gcp-hc-to-connect"
  description   = "Regra que permite com que o Google Health Check"
  target_tags   = ["gcp-hc"]
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
}

module "allow-gcp-nlb-to-connect" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/firewall-rule"
  project       = var.project
  vpc_name      = module.shared-vpc-main.vpc.name
  rule_name     = "allow-gcp-nlb-to-connect"
  description   = "Regra que permite com que o Google Network Load Balance"
  target_tags   = ["gcp-nlb"]
  source_ranges = ["35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22"]
}

module "allow-gcp-gke-master-nodes-admission" {
  source            = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/firewall-rule"
  project           = var.project
  vpc_name          = module.shared-vpc-main.vpc.name
  rule_name         = "allow-gcp-gke-master-nodes-admission"
  description       = "Regra que permite com que o Master node acesse a admission webhook"
  allowed_ports_tcp = ["8443"]
  target_tags       = ["gkenode"]
  source_ranges     = ["10.54.64.0/28", "10.54.64.16/28"]
}

module "allow-gcp-gke-master-nodes-proxy" {
  source            = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/firewall-rule"
  project           = var.project
  vpc_name          = module.shared-vpc-main.vpc.name
  rule_name         = "allow-gcp-gke-master-nodes-proxy"
  description       = "Regra que permite com que o Master node acesse para kube proxy"
  allowed_ports_tcp = ["8080", "9093", "9090"]
  target_tags       = ["gkenode"]
  source_ranges     = ["10.54.64.0/28", "10.54.64.16/28"]
}

module "gcp2p-allow-prod-splunk-receive-connections" {
  source            = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/firewall-rule"
  project           = var.project
  vpc_name          = module.shared-vpc-main.vpc.name
  rule_name         = "gcp2p-allow-prod-splunk-receive-connections"
  description       = "Regra que permite com que o Splunk receba conexoes"
  target_tags       = ["splunk-idx", "splunk-sh", "splunk-cm", "splunk-dp", "splunk-hf"]
  allowed_ports_tcp = ["8089", "9997", "9887", "9777", "8191", "8088", "8000"]
  source_ranges = [
    "10.54.20.0/24",
    "10.50.0.0/16",
    "10.19.0.0/24",
    "10.1.0.0/23",
    "10.51.0.0/16",
    "10.53.0.0/16",
    "10.52.0.0/16",
    "10.18.0.0/24",
    "10.18.1.0/24",
    "10.19.1.0/24",
    "10.19.2.0/24",
    "10.19.3.0/24",
    "10.45.32.0/24",
    "10.47.32.0/24",
    "10.60.0.0/16",
    "10.70.0.0/16",
    "10.45.0.0/21",
    "10.47.0.0/21",
    "10.18.2.0/24",
    "10.253.5.0/24",
    "10.58.0.0/16",
    "10.59.0.0/16",
    "10.75.0.0/16",
    "10.76.0.0/16",
    "10.91.0.0/16",
    "10.7.0.0/24",
    "10.56.0.0/16",
    "10.57.96.0/21"
  ]
}

/******************************************
	Regras de encaminhamento DNS para AD.
 *****************************************/
module "fw-conductor-com-br" {
  source       = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/dns-forwarding"
  project      = var.project
  name         = "conductor-com-br"
  description  = "Regra de encaminhamento da zona conductor.com.br para AD"
  dns_name     = "conductor.com.br."
  vpc_id       = module.shared-vpc-main.vpc.self_link
  ad_server_ip = var.ad_ip
}

module "fw-conductor-tecnologia" {
  source       = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/dns-forwarding"
  project      = var.project
  name         = "conductor-tecnologia"
  description  = "Regra de encaminhamento da zona conductor.tecnologia. para AD"
  dns_name     = "conductor.tecnologia."
  vpc_id       = module.shared-vpc-main.vpc.self_link
  ad_server_ip = var.ad_ip
}

module "fw-cdtcloud-tecnologia" {
  source       = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/dns-forwarding"
  project      = var.project
  name         = "cdtcloud-tecnologia"
  description  = "Regra de encaminhamento da zona cdtcloud.tecnologia. para AD"
  dns_name     = "cdtcloud.tecnologia."
  vpc_id       = module.shared-vpc-main.vpc.self_link
  ad_server_ip = var.ad_ip
}