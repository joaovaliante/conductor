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

variable "pier_enabled" {
  type        = bool
  description = "Enabled / Disabled Pier"
  default     = true
}

variable "heimdall_enabled" {
  type        = bool
  description = "Enabled / Disabled Heimdall"
  default     = true
}

variable "heimdall_version" {
  type        = string
  description = "Heimdall Version"
  default     = null
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
  type        = number
  description = "Heimdall New Replicas"
  default     = 5
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

variable "pier_replicas" {
  type        = number
  description = "Pier Replicas"
}

variable "pier_new_version_replicas" {
  type        = number
  description = "Pier New Replicas"
  default     = 5
}

variable "pier_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "#{PIER_CHART_VERSION}#"
}

variable "heimdall_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "#{HEIMDALL_CHART_VERSION}#"
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

variable "monitoring_datadog_environment" {
  type        = string
  description = "Monitoring Datadog environment"
  default     = "#{MONITORING_DATADOG_ENVIRONMENT}#"
}