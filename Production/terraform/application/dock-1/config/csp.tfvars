subscription        = "a4212e99-5f1e-474a-9b81-a689fbb09925"
cluster_name        = "dock-1"
resource_group_name = "RG_DOCK1"
rancher_url         = "https://rancher.conductor.com.br"

pier_dns = [
  "dock-1.conductor.com.br"
]

pier_enabled              = true
pier_version              = "2.204.0"
pier_replicas             = 20
pier_new_version          = null
pier_new_version_replicas = 10

heimdall_enabled = false