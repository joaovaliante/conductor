project      = "cdt-gke-1"
region       = "southamerica-east1"
cluster_name = "gke-1"
rancher_url  = "https://rancher.conductor.com.br"

pier_enabled              = true
pier_version              = "2.192.1"
pier_replicas             = 5
pier_new_version          = null
pier_new_version_replicas = 5

heimdall_enabled              = true
heimdall_version              = "2.17.0"
heimdall_replicas             = 20
heimdall_new_version          = null
heimdall_new_version_replicas = 5