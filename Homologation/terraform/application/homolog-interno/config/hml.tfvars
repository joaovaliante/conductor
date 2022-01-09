project      = "cdt-devops-hmli"
region       = "us-east1"
cluster_name = "homolog-interno"
rancher_url  = "https://rancher.devcdt.com.br"

#Pier
pier_cdc_dns     = "homolog-interno-cdc.devcdt.com.br"
pier_version     = "2.204.0"
pier_new_version = null

# Heimdall
heimdall_enabled              = true
heimdall_replicas             = 3
heimdall_new_version          = null
heimdall_new_version_replicas = 1

# Jarvis
jarvis_enabled     = true
jarvis_version     = "0.40.2"
jarvis_new_version = null

# Kafka
kafka_enabled     = true
kafka_version     = "6.0.1"
kafka_new_version = null