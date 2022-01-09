subscription        = "a4212e99-5f1e-474a-9b81-a689fbb09925"
cluster_name        = "global-2"
resource_group_name = "RG_GLOBAL2_BrazilSouth"
rancher_url         = "https://rancher.conductor.com.br"


# Pier
pier_dns = [
  "pier-global-2.conductor.com.br",
  "api.conductor.com.br",
]
pier_enabled              = true
pier_version              = "2.203.1"
pier_replicas             = 30
pier_new_version          = null
pier_new_version_replicas = 10

# Heimdall
heimdall_enabled              = true
heimdall_version              = "2.20.0"
heimdall_replicas             = 20
heimdall_new_version          = null
heimdall_new_version_replicas = 5