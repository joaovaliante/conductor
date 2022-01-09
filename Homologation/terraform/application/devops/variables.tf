# variaveis comuns
variable "project" {
  type        = string
  description = "ID do projeto na Google Cloud."
}

variable "region" {
  type        = string
  description = "Regiao principal a ser utilizada na Google Cloud."
}

/******************************************
Variaveis GKE
*****************************************/
variable "cluster_name" {
  type        = string
  description = "Cluster Name"
}

/******************************************
Rancher
*****************************************/
variable "rancher_cluster_name" {
  type        = string
  description = "Cluster Name"
}

variable "rancher_namespace" {
  type        = string
  description = "Rancher namespace"
  default     = "cattle-system"
}

variable "rancher_hostname" {
  type        = string
  description = "Rancher hostname"
}

variable "rancher_version" {
  type        = string
  description = "Rancher version"
}
variable "rancher_tls_cert" {
  type        = string
  description = "Certificate Value"
}

variable "rancher_tls_key" {
  type        = string
  description = "Certificate Value"
}

variable "monitoring_chart_version" {
  type        = string
  description = "Monitoring Chart version"
  default     = "#{MONITORING_CHART_VERSION}#"
}

/******************************************
Harness
*****************************************/
variable "harness_account_id" {
  type        = string
  sensitive   = true
  description = "Harness Account ID"
  default     = "#{HARNESS_ACCOUNT_ID}#"
}

variable "harness_account_secret" {
  type        = string
  sensitive   = true
  description = "Harness Account Secret"
  default     = "#{HARNESS_ACCOUNT_SECRET}#"
}

variable "harness_delegate_profile" {
  type        = string
  sensitive   = true
  description = "Harness Delegate Profile"
  default     = "#{HARNESS_DELEGATE_PROFILE}#"
}

variable "harness_manager_service_secret" {
  type        = string
  sensitive   = true
  description = "Harness Manager Service Secret"
  default     = "#{HARNESS_MANAGER_SERVICE_SECRET}#"
}

/******************************************
Kafka
*****************************************/
variable "kafka_watch_namespaces" {
  type        = list(string)
  description = "Kafka Watch Namespaces"
}

variable "registry_password" {
  type        = string
  description = "Registry password"
  default     = "#{REGISTRY_PASSWORD}#"
}

variable "kafka_splunk_connect_bootstrap_servers" {
  type        = string
  description = "Connect Servers"
}

variable "kafka_splunk_uri" {
  type        = string
  description = "Splunk URI"
  default     = "#{KAFKA_SPLUNK_URI}#"
}

variable "kafka_apim_splunk_token" {
  type        = string
  description = "Splunk APIM Hec Token"
  default     = "#{KAFKA_SPLUNK_TOKEN}#"
}

variable "kafka_connection_string" {
  type        = string
  description = "EventHub Connection String"
  default     = "#{KAFKA_CONNECTION_STRING}#"
}