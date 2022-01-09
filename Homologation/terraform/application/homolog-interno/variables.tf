/******************************************
Variaveis Comuns
*****************************************/
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
variable "rancher_url" {
  type        = string
  description = "Rancher Url"
}

variable "rancher_token" {
  type        = string
  description = "Rancher Token API"
  default     = "#{RANCHER_BEARER_TOKEN}#"
}

/******************************************
Registry
*****************************************/
variable "registry_password" {
  type        = string
  description = "Registry Password"
  default     = "#{REGISTRY_PASSWORD}#"
}

/******************************************
Variaveis Helm - Ingress
*****************************************/
variable "ingress_nginx_default_tls_cert" {
  type        = string
  description = "NGINX Ingress default certificate"
  default     = ""
}

variable "ingress_nginx_default_tls_key" {
  type        = string
  description = "NGINX Ingress default certificate key"
  default     = ""
}



/******************************************
Variaveis Helm - Loki
*****************************************/
variable "loki_chart" {
  type        = string
  description = "Loki chart"
  default     = "loki"
}

variable "loki_version" {
  type        = string
  description = "loki Version"
  default     = ""
}

/******************************************
Variaveis Helm - Mssql
*****************************************/
variable "mssql_chart" {
  type        = string
  description = "Mssql chart"
  default     = "mssql"
}

variable "mssql_version" {
  type        = string
  description = "Mssql Version"
  default     = ""
}


/******************************************
Variaveis Helm - Pier
*****************************************/
variable "pier_version" {
  type        = string
  description = "Pier Version"
  default     = null
}

variable "pier_new_version" {
  type        = string
  description = "Pier New Version"
  default     = null
}

variable "pier_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "#{PIER_CHART_VERSION}#"
}

variable "pier_cdc_dns" {
  type        = string
  description = "Pier CDC DNS"
}

/******************************************
Variaveis Helm - Heimdall
*****************************************/
variable "heimdall_enabled" {
  type        = bool
  description = "Enabled / Disabled Heimdall"
  default     = true
}

variable "heimdall_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "#{HEIMDALL_CHART_VERSION}#"
}

variable "heimdall_version_gateway" {
  type        = string
  description = "Heimdall Version"
  default     = "2.7.3-SNAPSHOT"
}

variable "heimdall_new_version" {
  type        = string
  description = "Heimdall New Version"
  default     = null
}

variable "heimdall_replicas" {
  type        = number
  description = "Heimdall Replicas"
}

variable "heimdall_new_version_replicas" {
  type        = string
  description = "Heimdall New Version Replicas"
  default     = null
}

/******************************************
Variaveis Helm - Neo
*****************************************/
variable "neo_chart_version" {
  type        = string
  description = "Neo Chart Version"
  default     = null
}

/******************************************
Variaveis Helm - Jarvis
*****************************************/
variable "jarvis_enabled" {
  type        = bool
  description = "Enabled / Disabled Jarvis"
  default     = true
}

variable "jarvis_version" {
  type        = string
  description = "Jarvis Version"
  default     = null
}

variable "jarvis_new_version" {
  type        = string
  description = "Jarvis New Version"
  default     = null
}

variable "jarvis_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "#{JARVIS_CHART_VERSION}#"
}

variable "jarvis_project" {
  type        = string
  description = "Jarvis Project Name"
  default     = "jarvis"
}

variable "jarvis_namespaces" {
  type        = list(string)
  description = "Jarvis Namespaces Name"
  default     = ["jarvis"]
}

/******************************************
Variaveis Helm - Kafka
*****************************************/
variable "kafka_enabled" {
  type        = bool
  description = "Enabled / Disabled Kafka"
  default     = true
}

variable "kafka_version" {
  type        = string
  description = "Kafka Version"
  default     = null
}

variable "kafka_new_version" {
  type        = string
  description = "Kafka New Version"
  default     = null
}

variable "kafka_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "#{KAFKA_CHART_VERSION}#"
}

variable "kafka_project" {
  type        = string
  description = "Kafka Project Name"
  default     = "kafka"
}

variable "kafka_namespaces" {
  type        = list(string)
  description = "Kafka Namespaces Name"
  default     = ["kafka"]
}

/******************************************
Monitoring
*****************************************/
variable "monitoring_datadog_environment" {
  type        = string
  description = "Monitoring Datadog environment"
  default     = "#{MONITORING_DATADOG_ENVIRONMENT}#"
}


#################################################################################################
################################## Revisão - Projeto Migração ###################################
#################################################################################################

/******************************************
Variaveis Helm - Rabbitmq
*****************************************/
variable "rabbitmq_chart" {
  type        = string
  description = "Rabbitmq chart"
  default     = "rabbitmq"
}

variable "rabbitmq_version" {
  type        = string
  description = "Rabbitmq Version"
  default     = ""
}

/******************************************
  Helm - HEIMDALL-PIER Application
 *****************************************/
variable "hp_heimdall_enabled" {
  type        = bool
  description = "Enabled / Disabled Heimdall"
  default     = true
}

variable "hp_heimdall_gateway_version" {
  type        = string
  description = "Heimdall Version"
  default     = "2.7.3-SNAPSHOT"
}

variable "hp_heimdall_new_version" {
  type        = string
  description = "Heimdall  New Version"
  default     = 1
}
variable "hp_heimdall_new_version_replicas" {
  type        = number
  description = "Heimdall New Version Replicas"
  default     = 1
}
variable "hp_heimdall_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "0.5.0"
}

variable "hp_pier_enabled" {
  type        = bool
  description = "Enabled / Disabled Pier"
  default     = true
}

variable "hp_pier_version" {
  type        = string
  description = "Pier Version"
  default     = "2.207.1"
}

variable "hp_pier_new_version" {
  type        = string
  description = "Pier New Version"
  default     = null
}

variable "hp_pier_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "1.1.4"
}
variable "hp_neo_chart_version" {
  type        = string
  description = "Neo Chart Version"
  default     = "0.1.1"
}

/******************************************
  Helm - SGR-STORE Application
 *****************************************/
variable "store_chart_version" {
  type        = string
  description = "SGR STORE Chart Version"
  default     = "0.0.2"
}