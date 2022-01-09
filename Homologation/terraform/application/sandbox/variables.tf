# variaveis comuns
variable "project" {
  type        = string
  description = "ID do projeto na Google Cloud."
}

variable "region" {
  type        = string
  description = "Regiao principal a ser utilizada na Google Cloud."
}

variable "registry_password" {
  type        = string
  description = "Registry Password"
  default     = "#{REGISTRY_PASSWORD}#"
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
Variaveis Helm - Applications
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

variable "pier_dock_dns" {
  type        = string
  description = "Pier Dock DNS"
}

variable "pier_arbi_dns" {
  type        = string
  description = "Pier Arbi DNS"
}

variable "pier_harness_dns" {
  type        = string
  description = "Pier Harness DNS"
}

variable "monitoring_datadog_environment" {
  type        = string
  description = "Monitoring Datadog environment"
  default     = "#{MONITORING_DATADOG_ENVIRONMENT}#"
}

/*******************************************
Variaveis Helm - VISA-DIRECT
*****************************************/

variable "visadirect_username" {
  type        = string
  description = "Visa-Direct Username"
  default     = "#{VISADIRECT_USERNAME}#"
}

variable "visadirect_password" {
  type        = string
  description = "Visa-Direct Password"
  default     = "#{VISADIRECT_PASSWORD}#"
}

variable "visadirect_mleidkey_password" {
  type        = string
  description = "Visa-Direct Mleidkey"
  default     = "#{VISADIRECT_MLEIDKEY}#"
}


#################################################################################################
################################## Projeto Migração Sandbox  ####################################
#################################################################################################

/******************************************
  Helm - Rabbitmq
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
  Helm - BMG Application
 *****************************************/
variable "bmg_heimdall_enabled" {
  type        = bool
  description = "Enabled / Disabled Heimdall"
  default     = true
}

variable "bmg_heimdall_version" {
  type        = string
  description = "Heimdall Version"
  default     = "2.7.3-SNAPSHOT"
}

variable "bmg_heimdall_new_version" {
  type        = string
  description = "Heimdall  New Version"
  default     = 1
}
variable "bmg_heimdall_new_version_replicas" {
  type        = number
  description = "Heimdall New Version Replicas"
  default     = 1
}
variable "bmg_heimdall_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "0.5.0"
}

variable "bmg_pier_enabled" {
  type        = bool
  description = "Enabled / Disabled Pier"
  default     = true
}

variable "bmg_pier_version" {
  type        = string
  description = "Pier Version"
  default     = "2.210.0"
}

variable "bmg_pier_new_version" {
  type        = string
  description = "Pier New Version"
  default     = null
}

variable "bmg_pier_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "1.1.4"
}

variable "bmg_sgr_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "0.0.2"
}

/******************************************
  Helm - C6BANK Application
 *****************************************/
variable "c6bank_heimdall_enabled" {
  type        = bool
  description = "Enabled / Disabled Heimdall"
  default     = true
}

variable "c6bank_heimdall_version" {
  type        = string
  description = "Heimdall Version"
  default     = "2.7.3-SNAPSHOT"
}

variable "c6bank_heimdall_new_version" {
  type        = string
  description = "Heimdall  New Version"
  default     = 1
}
variable "c6bank_heimdall_new_version_replicas" {
  type        = number
  description = "Heimdall New Version Replicas"
  default     = 1
}
variable "c6bank_heimdall_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "0.5.0"
}

variable "c6bank_pier_enabled" {
  type        = bool
  description = "Enabled / Disabled Pier"
  default     = true
}

variable "c6bank_pier_version" {
  type        = string
  description = "Pier Version"
  default     = "2.210.0"
}

variable "c6bank_pier_new_version" {
  type        = string
  description = "Pier New Version"
  default     = null
}

variable "c6bank_pier_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "1.1.4"
}

/******************************************
  Helm - CBSS Application
 *****************************************/
variable "cbss_heimdall_enabled" {
  type        = bool
  description = "Enabled / Disabled Heimdall"
  default     = true
}

variable "cbss_heimdall_version" {
  type        = string
  description = "Heimdall Version"
  default     = "2.7.3-SNAPSHOT"
}

variable "cbss_heimdall_new_version" {
  type        = string
  description = "Heimdall  New Version"
  default     = 1
}
variable "cbss_heimdall_new_version_replicas" {
  type        = number
  description = "Heimdall New Version Replicas"
  default     = 1
}
variable "cbss_heimdall_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "0.5.0"
}

variable "cbss_pier_enabled" {
  type        = bool
  description = "Enabled / Disabled Pier"
  default     = true
}

variable "cbss_pier_version" {
  type        = string
  description = "Pier Version"
  default     = "2.210.0"
}

variable "cbss_pier_new_version" {
  type        = string
  description = "Pier New Version"
  default     = null
}

variable "cbss_pier_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "1.1.4"
}

/*******************************************
  Helm - CIPHER Application
*****************************************/
variable "cipher_chart_version" {
  type        = string
  description = "Cipher Chart Version"
  default     = null
}

/******************************************
  Helm - CREFISA Application
 *****************************************/
variable "crefisa_heimdall_enabled" {
  type        = bool
  description = "Enabled / Disabled Heimdall"
  default     = true
}

variable "crefisa_heimdall_version" {
  type        = string
  description = "Heimdall Version"
  default     = "2.7.3-SNAPSHOT"
}

variable "crefisa_heimdall_new_version" {
  type        = string
  description = "Heimdall  New Version"
  default     = 1
}
variable "crefisa_heimdall_new_version_replicas" {
  type        = number
  description = "Heimdall New Version Replicas"
  default     = 1
}
variable "crefisa_heimdall_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "0.5.0"
}

variable "crefisa_pier_enabled" {
  type        = bool
  description = "Enabled / Disabled Pier"
  default     = true
}

variable "crefisa_pier_version" {
  type        = string
  description = "Pier Version"
  default     = "2.210.0"
}

variable "crefisa_pier_new_version" {
  type        = string
  description = "Pier New Version"
  default     = null
}

variable "crefisa_pier_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "1.1.4"
}

/******************************************
  Helm - HEIMDALL-PIER Application
 *****************************************/
variable "hp_heimdall_enabled" {
  type        = bool
  description = "Enabled / Disabled Heimdall"
  default     = true
}

variable "hp_heimdall_version" {
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
  default     = "2.210.0"
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
  Helm - PB Application
 *****************************************/
variable "pb_heimdall_enabled" {
  type        = bool
  description = "Enabled / Disabled Heimdall"
  default     = true
}

variable "pb_heimdall_version" {
  type        = string
  description = "Heimdall Version"
  default     = "2.7.3-SNAPSHOT"
}

variable "pb_heimdall_new_version" {
  type        = string
  description = "Heimdall  New Version"
  default     = 1
}
variable "pb_heimdall_new_version_replicas" {
  type        = number
  description = "Heimdall New Version Replicas"
  default     = 1
}
variable "pb_heimdall_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "0.5.0"
}

variable "pb_pier_enabled" {
  type        = bool
  description = "Enabled / Disabled Pier"
  default     = true
}

variable "pb_pier_version" {
  type        = string
  description = "Pier Version"
  default     = "2.210.0"
}

variable "pb_pier_new_version" {
  type        = string
  description = "Pier New Version"
  default     = null
}

variable "pb_pier_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "1.1.4"
}

variable "pb_sgr_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "0.0.2"
}

/******************************************
  Helm - SGR-STORE Application
 *****************************************/
variable "store_chart_version" {
  type        = string
  description = "SGR STORE Chart Version"
  default     = "0.0.2"
}

variable "kafka_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "#{KAFKA_CHART_VERSION}#"
}

variable "kafka_version" {
  type        = string
  description = "Kafka Version"
  default     = null
}

/******************************************
  Helm - Sandbox Application
 *****************************************/
variable "sandbox_heimdall_enabled" {
  type        = bool
  description = "Enabled / Disabled Heimdall"
  default     = true
}

variable "sandbox_heimdall_version" {
  type        = string
  description = "Heimdall Version"
  default     = "2.7.3-SNAPSHOT"
}

variable "sandbox_heimdall_new_version" {
  type        = string
  description = "Heimdall  New Version"
  default     = 1
}
variable "sandbox_heimdall_new_version_replicas" {
  type        = number
  description = "Heimdall New Version Replicas"
  default     = 1
}
variable "sandbox_heimdall_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "0.5.0"
}

variable "sandbox_pier_enabled" {
  type        = bool
  description = "Enabled / Disabled Pier"
  default     = true
}

variable "sandbox_pier_version" {
  type        = string
  description = "Pier Version"
  default     = "2.210.0"
}

variable "sandbox_pier_new_version" {
  type        = string
  description = "Pier New Version"
  default     = null
}

variable "sandbox_pier_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "1.1.4"
}

variable "sandbox_sgr_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "0.0.2"
}
