subscription        = "a4212e99-5f1e-474a-9b81-a689fbb09925"
cluster_name        = "cbss-1"
resource_group_name = "RG_Cbss"
rancher_url         = "https://rancher.conductor.com.br"

pier_dns = [
  "cbss-1.conductor.com.br"
]

pier_enabled              = true
pier_version              = "2.204.0"
pier_replicas             = 30
pier_new_version          = null
pier_new_version_replicas = 10

heimdall_enabled              = true
heimdall_version              = "2.17.0"
heimdall_replicas             = 20
heimdall_new_version          = null
heimdall_new_version_replicas = 5