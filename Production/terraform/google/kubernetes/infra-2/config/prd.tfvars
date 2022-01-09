project               = "cdt-infra-prd"
region                = "southamerica-east1"
env_name              = "prd"
cluster_name          = "infra-2"
host_subnet_name      = "gcp2p-subnet-gke-infra-2"
node_locations        = ["southamerica-east1-a", "southamerica-east1-b", "southamerica-east1-c"]
project_services_apis = ["cloudresourcemanager.googleapis.com", "compute.googleapis.com", "iam.googleapis.com", "logging.googleapis.com", "monitoring.googleapis.com", "container.googleapis.com", ]
rancher_url           = "https://rancher.conductor.com.br"