subscription        = "a4212e99-5f1e-474a-9b81-a689fbb09925"
cluster_name        = "global-1"
resource_group_name = "RG_GLOBAL1_BrazilSouth"
rancher_url         = "https://rancher.conductor.com.br"

# Pier
pier_dns = [
  "pier-global-1.conductor.com.br",
  "api.conductor.com.br",
]
pier_enabled              = true
pier_version              = "2.201.0"
pier_replicas             = 30
pier_new_version          = null
pier_new_version_replicas = 0

# Heimdall
heimdall_enabled              = true
heimdall_version              = "2.17.0"
heimdall_replicas             = 10
heimdall_new_version          = "2.20.0"
heimdall_new_version_replicas = 10

# Mercurio
mercurio_push_version = "2.0.4"
mercurio_sms_version  = "1.17.0"