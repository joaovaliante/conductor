project               = "cdt-gke-1"
region                = "southamerica-east1"
env_name              = "prd"
cluster_name          = "gke-1"
host_subnet_name      = "gcp2p-subnet-gke-1"
node_locations        = ["southamerica-east1-a", "southamerica-east1-b"]
project_services_apis = ["cloudresourcemanager.googleapis.com", "compute.googleapis.com", "iam.googleapis.com", "logging.googleapis.com", "monitoring.googleapis.com", "container.googleapis.com", ]
rancher_url           = "https://rancher.conductor.com.br"

# Destroy Cluster
# ingress_nginx_enabled      = false
# heimdall_enabled           = false
# pier_enabled               = false
# rancher_monitoring_enabled = false
odin_primary_enabled   = false
odin_secondary_enabled = false