subscription        = "a4212e99-5f1e-474a-9b81-a689fbb09925"
cluster_name        = "dock-2"
resource_group_name = "RG_DOCK2"
rancher_url         = "https://rancher.conductor.com.br"

pier_dns = [
  "dock-2.conductor.com.br"
]

pier_enabled              = true
pier_version              = "2.204.0"
pier_replicas             = 20
pier_new_version          = null
pier_new_version_replicas = 10

heimdall_enabled = false