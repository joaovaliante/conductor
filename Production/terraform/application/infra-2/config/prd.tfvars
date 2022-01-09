#Azure
subscription                  = "a4212e99-5f1e-474a-9b81-a689fbb09925"
resource_group_name           = "RG_API_MANAGEMENT"
resource_group_name_secondary = "RG_API_MANAGEMENT_Brazil_Southeast"
#Google
project      = "cdt-infra-prd"
region       = "southamerica-east1"
cluster_name = "infra-2"
rancher_url  = "https://rancher.conductor.com.br"

kafka_splunk_connect_version                     = "2.8.0"
kafka_splunk_connect_bootstrap_servers           = "az1p-eventhub-apim.servicebus.windows.net:9093"
kafka_splunk_connect_bootstrap_servers_secondary = "az3p-eventhub-apim.servicebus.windows.net:9093"
kafka_splunk_uri                                 = "https://10.54.20.52:8088"
kafka_watch_namespaces = [
  "kafka"
]
