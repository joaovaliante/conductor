project              = "cdt-devops-hmli"
region               = "us-east1"
cluster_name         = "devops"
rancher_cluster_name = "local"
rancher_hostname     = "rancher.devcdt.com.br"
rancher_version      = "v2.5.8"

kafka_watch_namespaces = [
  "kafka"
]
kafka_splunk_connect_bootstrap_servers = "event-hub-splunk.servicebus.windows.net:9093"