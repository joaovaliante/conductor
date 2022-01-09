/******************************************
Azure
*****************************************/
variable "subscription" {
  type        = string
  description = "Subscription ID"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "resource_group_name_secondary" {
  type        = string
  description = "Resource group name"
}
/******************************************
Google
*****************************************/
variable "project" {
  type        = string
  description = "ID do projeto na Google Cloud."
}

variable "region" {
  type        = string
  description = "Regiao principal a ser utilizada na Google Cloud."
}

variable "cluster_name" {
  type        = string
  description = "Cluster Name"
}

variable "rancher_url" {
  type        = string
  description = "Rancher Url"
}

variable "rancher_token" {
  type        = string
  description = "Rancher Token API"
  default     = "#{RANCHER_BEARER_TOKEN}#"
}

variable "kafka_watch_namespaces" {
  type        = list(string)
  description = "Kafka Watch Namespaces"
}

variable "registry_password" {
  type        = string
  description = "Registry password"
  default     = "#{REGISTRY_PASSWORD}#"
}

variable "kafka_splunk_connect_version" {
  type        = string
  description = "Kafka Connect Splunk Version"
}

variable "kafka_splunk_connect_bootstrap_servers" {
  type        = string
  description = "Connect Servers"
}

variable "kafka_splunk_connect_bootstrap_servers_secondary" {
  type        = string
  description = "Connect Servers"
}

variable "kafka_splunk_uri" {
  type        = string
  description = "Splunk URI"
}

variable "kafka_apim_splunk_token" {
  type        = string
  description = "Splunk APIM Hec Token"
  default     = "#{KAFKA_SPLUNK_TOKEN}#"
}

variable "kafka_appgw_splunk_token" {
  type        = string
  description = "Splunk Application Gateway Hec Token"
  default     = "#{KAFKA_APPGW_SPLUNK_TOKEN}#"
}

variable "kafka_apim_splunk_source" {
  type        = string
  description = "Splunk Apim Source"
  default     = "apim:hec"
}

variable "kafka_apim_splunk_sourcetype_gateway" {
  type        = string
  description = "Splunk Gateway Sourcetype"
  default     = "apim:request"
}

variable "kafka_apim_splunk_sourcetype_cache" {
  type        = string
  description = "Splunk Cache Sourcetype"
  default     = "apim:cache"
}

variable "kafka_appgw_splunk_source" {
  type        = string
  description = "Splunk Application Gateway Source"
  default     = "appgw:hec"
}

variable "kafka_appgw_splunk_sourcetype_access" {
  type        = string
  description = "Splunk Application Gateway Sourcetype"
  default     = "appgw:access"
}